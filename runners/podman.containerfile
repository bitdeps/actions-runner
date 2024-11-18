FROM ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295

ARG TARGETARCH
# renovate: datasource=github-releases depName=actions/runner
ARG RUNNER_VERSION=2.320.0
# renovate: datasource=github-releases depName=mgoltzsche/podman-static
ARG PODMAN_VERSION=4.9.5
# renovate: datasource=github-releases depName=containers/crun
ARG CRUN_VERSION=1.18.2
# renovate: datasource=github-releases depName=cli/cli
ARG TOOL_GH_VERSION=2.62.0

ENV RUNNER_TOOLS_BIN=/runner/tools/bin

# Fetch deps and prepare
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        wget curl git lsb-release unzip uidmap libcap2-bin iptables sudo tini \
        apt-transport-https gnupg \
    && mkdir -p $RUNNER_TOOLS_BIN \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Create runner user (1001:1001) with subordinate id mappings
RUN useradd -u 1001 -Um -d /home/runner -s /bin/bash runner \
    && printf "runner:1:1000\nrunner:1002:64535\n" | tee /etc/subuid > /etc/subgid \
    && mkdir -p /run/user/1001 \
    && chown runner:runner /run/user/1001 \
    && chmod a+x /run/user/1001 \
    ## Volumes might be passed with nosuid flag, this doesn't work well on debian/ubuntu! \
    ## So suid/sgid bits are removed from uid mapping binaries and capabilites are set directly. \
    && chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap \
    && setcap cap_setuid+ep /usr/bin/newuidmap \
    && setcap cap_setgid+ep /usr/bin/newgidmap

## Install static podman
RUN \
    curl -sL https://github.com/mgoltzsche/podman-static/releases/download/v${PODMAN_VERSION}/podman-linux-${TARGETARCH}.tar.gz | tar xzC /tmp \
    && curl -sL https://github.com/containers/crun/releases/download/${CRUN_VERSION}/crun-${CRUN_VERSION}-linux-${TARGETARCH}-disable-systemd -o \
        /usr/local/bin/crun && chmod 755 /usr/local/bin/crun \
    && dist=/tmp/podman-linux-${TARGETARCH}; cp -r ${dist}/etc ${dist}/usr / \
    # Make podman-static (intentional, so that container jobs don't invoke podman directly) \
    && ln /usr/local/bin/podman $RUNNER_TOOLS_BIN/podman-static  \
    # remove runc and clean up \
    && rm /usr/local/bin/runc && rm -rf /tmp/*

## Install Github Actions runner
ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
COPY --chmod=755 install-runner /usr/bin
RUN RUNNER_VERSION=${RUNNER_VERSION} install-runner \
    && /home/runner/bin/installdependencies.sh \
    && apt-get -y clean && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    # Setup hosted toolcache directory \
    && mkdir /opt/hostedtoolcache \
    && chgrp runner /opt/hostedtoolcache \
    && chmod g+rwx /opt/hostedtoolcache

##  Setup container jobs tools and configuration
COPY --chmod=755 buildah.sh $RUNNER_TOOLS_BIN/buildah
RUN cd /tmp; \
    # install static gh cli \
    curl -sL https://github.com/cli/cli/releases/download/v${TOOL_GH_VERSION}/gh_${TOOL_GH_VERSION}_linux_${TARGETARCH}.tar.gz | \
        tar -xz && mv gh_${TOOL_GH_VERSION}_linux_${TARGETARCH}/bin/gh $RUNNER_TOOLS_BIN \
    && rm -rf /tmp/*

## Remote wrappers used by container jobs podman/docker 
COPY --chmod=755 podman-remote.sh $RUNNER_TOOLS_BIN/podman
RUN ln $RUNNER_TOOLS_BIN/podman $RUNNER_TOOLS_BIN/docker

## Setup runner configuration and scripts
COPY --chmod=755 docker-compat.sh /usr/bin/docker
COPY containers /etc/containers
COPY runner/hooks /runner/hooks
COPY --chown=runner:runner runner/containers.conf /home/runner/.config/containers/
COPY --chown=runner:runner runner/env /home/runner/.env
COPY --chmod=755 entrypoint.sh /usr/bin

## Runner environment
## Note: runner_tools_bin contains podman and docker should not override those used
##       by the runner, i.e have lower priority in the PATH
## 
ENV PATH="${PATH}:/home/runner/.local/bin:/home/runner/bin:${RUNNER_TOOLS_BIN}"
ENV ImageOS=ubuntu22
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1
ENV XDG_RUNTIME_DIR=/run/user/1001
ENV DOCKER_HOST=unix:///run/user/1001/podman/podman.sock
ENV _CONTAINERS_USERNS_CONFIGURED=""
## Note: Forces container jobs only mode!
ENV ACTIONS_RUNNER_REQUIRE_JOB_CONTAINER=true
## Use the fix to mitigate startup on ubuntu 24.04
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

## Misc
RUN echo "PATH=${PATH}" > /etc/environment \
    && echo "ImageOS=${ImageOS}" >> /etc/environment \
    && echo "DOCKER_HOST=${DOCKER_HOST}" >> /etc/environment \
    && echo "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}" >> /etc/environment \
    && mkdir -p /home/runner/.local/bin /home/runner/.local/share/containers \
    && chown -R runner:runner /home/runner/.local \
    # switch to legacy iptables for better compatibility \
    && update-alternatives --set iptables /usr/sbin/iptables-legacy

# install docker registry auth providers
RUN \
    # gcloud \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
      gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
      tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get -y update && apt-get install -y google-cloud-cli \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure docker auth
COPY --chown=runner:runner docker.json /home/runner/.docker/config.json

WORKDIR /home/runner
VOLUME ["/home/runner/.local/share/containers"]
USER runner
ENTRYPOINT ["tini", "--", "/usr/bin/entrypoint.sh"]

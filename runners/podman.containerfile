FROM mgoltzsche/podman:4.9.3-minimal as podman

# Note: github actions runner is dynamically linked and linux runner supports ubuntu only
FROM ubuntu:jammy

ARG TARGETARCH
ARG RUNNER_VERSION=""
ARG PODMAN_VERSION="4.9.3"
ARG CRUN_VERSION="1.14.4"
ARG GH_CLI_VERSION="2.45.0"

# Fetch deps
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        wget curl git lsb-release unzip uidmap libcap2-bin iptables sudo tini \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add runner user with subordinate id mappings for runner user (1001:1001)
RUN useradd -u 1001 -Um -d /home/runner -s /bin/bash runner \
    && printf "runner:1:1000\nrunner:1002:64535\n" | tee /etc/subuid > /etc/subgid \
    && mkdir -p /run/user/1001 \
    && chown runner:runner /run/user/1001 \
    && chmod a+x /run/user/1001

## Note: volumes are likely to be passed with nosuid flag, this doesn't work with debian setup.
##       We need to drop suid/sgid for uid mapping binaries and set capabilites directly.
RUN chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap \
    && setcap cap_setuid+ep /usr/bin/newuidmap \
    && setcap cap_setgid+ep /usr/bin/newgidmap

## Install runner
COPY --chmod=755 install-runner /usr/bin
RUN install-runner && /home/runner/bin/installdependencies.sh \
    && apt-get -y clean && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install static podman
RUN mkdir -p /runner/tools/bin \
    && curl -sL https://github.com/mgoltzsche/podman-static/releases/download/v${PODMAN_VERSION}/podman-linux-${TARGETARCH}.tar.gz | tar xzC /tmp \
    && curl -sL https://github.com/containers/crun/releases/download/${CRUN_VERSION}/crun-${CRUN_VERSION}-linux-${TARGETARCH}-disable-systemd -o \
        /usr/local/bin/crun && chmod 755 /usr/local/bin/crun \
    && dist=/tmp/podman-linux-${TARGETARCH}; cp -r ${dist}/etc ${dist}/usr / \
    # remove runc and clean up \
    && rm /usr/local/bin/runc && rm -rf $dist \
    # create link to static podman \
    && ln /usr/local/bin/podman /runner/tools/bin

## Toolcache
ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
RUN mkdir /opt/hostedtoolcache \
    && chgrp runner /opt/hostedtoolcache \
    && chmod g+rwx /opt/hostedtoolcache

##  Setup tools
RUN mkdir -p /runner/tools/bin \
    # gh cli \
    && curl -fLo gh.tgz https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_${TARGETARCH}.tar.gz \
    && tar -xzf gh.tgz && mv gh_${GH_CLI_VERSION}_linux_${TARGETARCH}/bin/gh /runner/tools/bin \
    && rm -rf /tmp/*

COPY --chmod=755 docker-compat.sh /usr/bin/docker
COPY --chmod=755 docker-remote.sh /runner/tools/bin/docker
COPY containers /etc/containers
COPY runner/hooks /runner/hooks
COPY --chown=runner:runner runner/containers.conf /home/runner/.config/containers/
COPY --chown=runner:runner runner/env /home/runner/.env

## Env
ENV PATH="${PATH}:/home/runner/.local/bin:/home/runner/bin:/runner/tools/bin"
ENV ImageOS=ubuntu22
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1
ENV XDG_RUNTIME_DIR=/run/user/1001
ENV DOCKER_HOST=unix:///run/user/1001/podman/podman.sock
ENV _CONTAINERS_USERNS_CONFIGURED=""

RUN echo "PATH=${PATH}" > /etc/environment \
    && echo "ImageOS=${ImageOS}" >> /etc/environment \
    && echo "DOCKER_HOST=${DOCKER_HOST}" >> /etc/environment \
    && echo "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}" >> /etc/environment \
    && mkdir -p /home/runner/.local/bin /home/runner/.local/share/containers \
    && chown -R runner:runner /home/runner/.local

WORKDIR /home/runner
VOLUME ["/home/runner/.local/share/containers"]
USER runner

COPY --chmod=755 entrypoint.sh /usr/bin
ENTRYPOINT ["tini", "--", "/usr/bin/entrypoint.sh"]

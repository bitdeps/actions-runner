FROM ubuntu:24.04@sha256:b59d21599a2b151e23eea5f6602f4af4d7d31c4e236d22bf0b62b86d2e386b8f

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        ca-certificates lsb-release sudo fakeroot \
        curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel time file netcat-openbsd \
        make git jq yq gpg just less \
    # gcc is required for kcl to run \
        gcc \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fetch tools
RUN \
    # grab latest taskfile and just  \
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin \
    && wget -qO- "https://github.com/casey/just/releases/download/1.38.0/just-1.38.0-x86_64-unknown-linux-musl.tar.gz" | \
        tar xzf - -C /tmp && mv /tmp/just /usr/local/bin \
    # Get delta \
    && cd /tmp; curl -sSLO "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb" && \
        dpkg -i git-delta_0.18.2_amd64.deb \
    # grab KCL \
    # ref: https://github.com/kcl-lang/kcl/issues/1668 \
    && curl -sSL https://kcl-lang.io/script/install-cli.sh | /bin/bash -s -- 0.9.8 \
    && apt-get -y clean && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/*


RUN \
    # gcloud
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
        && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
        && apt-get -y update && apt-get -y install google-cloud-cli \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

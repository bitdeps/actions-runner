FROM ubuntu:22.04@sha256:3c61d3759c2639d4b836d32a2d3c83fa0214e36f195a3421018dbaaf79cbe37f

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        ca-certificates lsb-release sudo fakeroot \
        curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel time file netcat-openbsd \
        make git jq less \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    # Get delta \
    cd /tmp; curl -sSLO "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb" && \
        dpkg -i git-delta_0.18.2_amd64.deb \
    && apt-get -y clean && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/*

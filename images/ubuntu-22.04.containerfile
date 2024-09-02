FROM ubuntu:22.04@sha256:adbb90115a21969d2fe6fa7f9af4253e16d45f8d4c1e930182610c4731962658

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        ca-certificates lsb-release sudo fakeroot \
        curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel time file netcat-openbsd \
        make git jq \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

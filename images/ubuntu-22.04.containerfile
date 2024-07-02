FROM ubuntu:22.04@sha256:340d9b015b194dc6e2a13938944e0d016e57b9679963fdeb9ce021daac430221

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        ca-certificates lsb-release sudo fakeroot \
        curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel time file netcat-openbsd \
        make git jq \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

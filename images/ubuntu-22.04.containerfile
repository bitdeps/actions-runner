FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        ca-certificates lsb-release fakeroot \
        curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel time file netcat \
        git jq \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

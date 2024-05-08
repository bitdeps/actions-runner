FROM ubuntu:24.04@sha256:3f85b7caad41a95462cf5b787d8a04604c8262cdcdf9a472b8c52ef83375fe15

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update && apt-get install -y \
        ca-certificates lsb-release fakeroot \
        curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel time file netcat \
        make git jq \
    # clean up \
    && apt-get -y clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

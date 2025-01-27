FROM ubuntu:22.04@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97

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
    && wget -qO- "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb" | \
        dpkg -i /dev/stdin \
    && apt-get -y clean && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/*

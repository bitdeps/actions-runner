FROM node:22.3.0-alpine3.19@sha256:075a5cc188c3c9a49acacd481a9e8a3c9abf4223f02c658e37fdb8e9fe2c4664

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

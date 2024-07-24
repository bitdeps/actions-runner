FROM node:22.4.0-alpine3.19@sha256:8aeecd60c705f823fde29e175d8c8e8f123d00a1a9bd5a4320670a02c5527182

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

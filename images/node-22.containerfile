FROM node:22.2.0-alpine3.19@sha256:e6d449575e1696cbaee6ec1adce2ac220dc138c4b7bc053379b53c68a6bd2799

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

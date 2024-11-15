FROM node:22.11.0-alpine3.19@sha256:844f517e92fb8f226a52f29ed5c2b5994ae0dd05e152fefac3f2399469701234

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

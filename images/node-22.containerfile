FROM node:22.6.0-alpine3.19@sha256:eff1d6375c1f6102f1a39553aec1be773e3a62cf39251bc2517c3a95a4f28af3

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

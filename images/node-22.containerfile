FROM node:22.6.0-alpine3.19@sha256:30c5be9215c0ab992925f025a388d41e9be66c159a6cefb8f132ba829874e7f7

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

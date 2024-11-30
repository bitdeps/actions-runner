FROM node:23.3.0-alpine3.19@sha256:1c380ed40f8d2f42081a07e8bcea5048b18df1e1dab3e6191e0ad095c84b9e12

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

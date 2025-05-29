# renovate: datasource=docker depName=ubuntu versioning=ubuntu allowedVersions=22.04
FROM node:22-alpine

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

FROM node:22.4.0-alpine3.19@sha256:138d0b5f22718a61ceb6a6d306050fbdb599c35f4bb472bc996e540b14cd76ed

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

FROM node:22.3.0-alpine3.19@sha256:fb81e1779cfd51c3ee1bf01119a665eb82c97f3a5d609cc8a63e0ff88ef844e0

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

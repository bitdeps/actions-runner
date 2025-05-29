FROM node:22-alpine@sha256:9f3ae04faa4d2188825803bf890792f33cc39033c9241fc6bb201149470436ca

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

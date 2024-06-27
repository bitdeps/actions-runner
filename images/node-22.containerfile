FROM node:22.3.0-alpine3.19@sha256:9af472b2578996eb3d6affbcb82fdee6f086da2c43121e75038a4a70317f784f

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

FROM node:22-alpine@sha256:0340fa682d72068edf603c305bfbc10e23219fb0e40df58d9ea4d6f33a9798bf

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

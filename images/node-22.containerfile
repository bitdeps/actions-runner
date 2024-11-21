FROM node:23.2.0-alpine3.19@sha256:416fdb6cb5dbb08184ffde134fe543b014b058ed21c373767832410b25ec3662

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

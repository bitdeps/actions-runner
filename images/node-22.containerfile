FROM node:22-alpine@sha256:fa5f57793a2553cd6d40ef234d8f51c4c1df73284f14acf877e36bb7801d257c

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

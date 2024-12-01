FROM node:23.3.0-alpine3.19@sha256:4ebaf825598cb2f47eb2a52c4a0badf800681b49064e9cae73d3ae7a31a7ee44

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

FROM node:24-alpine@sha256:dfea0736e82fef246aba86b2082a5e86c4825470302692b841d097dd61253b79

RUN apk --no-cache add \
        ca-certificates fakeroot coreutils sudo tar \
        bash curl wget rsync \
        bzip2 unzip zip \
        openssh-client parallel file netcat-openbsd \
        make git jq yq

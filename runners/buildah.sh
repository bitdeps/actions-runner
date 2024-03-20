#!/bin/sh
# change buildah bud => podman build
if [ "$1" = "bud" ]; then shift; set -- build "$@"; fi
exec /runner/tools/bin/podman "$@"

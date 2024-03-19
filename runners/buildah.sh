#!/bin/sh
export CONTAINER_HOST=unix:///runner/podman.sock
export DOCKER_HOST=unix:///runner/podman.sock

# Change buildah bud => podman build
if [ "$1" = "bud" ]; then
  shift; set -- build "$@"
fi

exec /runner/tools/bin/podman --remote "$@"

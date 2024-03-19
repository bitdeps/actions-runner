#!/bin/sh
export CONTAINER_HOST=unix:///runner/podman.sock
export DOCKER_HOST=unix:///runner/podman.sock
exec /runner/tools/bin/podman-static --remote "$@"

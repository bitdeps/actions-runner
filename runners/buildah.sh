#!/bin/sh

## Filter args (omit podman incompatible)
for arg do
  shift
  ( echo "$arg" |
    grep -Ew '\--tls-verify=[^ ]{1,}' 1>/dev/null 2>&1
  ) && continue
  set -- "$@" "$arg"
done

# change buildah bud => podman build
if [ "$1" = "bud" ]; then shift; set -- build "$@"; fi
exec /runner/tools/bin/podman "$@"

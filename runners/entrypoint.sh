#!/bin/bash

## Preload images
pull_images() {
  local pull_tags; declare -A pull_tags
  pull_tags=(
    ["images/ubuntu"]="latest 22.04"
  )

  echo "=> Updating local image cache..."
  grep 'bitdeps/actions-runner/images/' < /etc/containers/registries.conf.d/000-shortnames.conf | sed -e 's@=.*@@' -e 's@"@@g' | while read -r alias; do
    if [[ -n "${pull_tags[$alias]}" ]]; then
      for tag in ${pull_tags[$alias]}; do
        podman pull "${alias}:${tag}"
      done
    fi
  done
}

# Update runner
install-runner
pull_images

podman system service --time=0 &
exec bash "$@"

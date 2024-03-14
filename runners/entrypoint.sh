#!/bin/bash

# update runner
install-runner

# prepull containers
grep 'bitdeps/actions-runner/images/' < /etc/containers/registries.conf.d/000-shortnames.conf | sed -e 's@=.*@@' -e 's@"@@g' | xargs -n1 podman pull

podman system service --time=0 &
exec bash

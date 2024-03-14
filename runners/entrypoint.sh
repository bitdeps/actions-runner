#!/bin/bash
# update runner
install-runner
podman system service --time=0 &
exec bash

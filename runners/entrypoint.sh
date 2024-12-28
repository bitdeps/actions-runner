#!/bin/bash

# Start podman socket
podman system service --time=0 &

if (! which "$1" 1>/dev/null 2>/dev/null ) && [ ! -x "$1" ]; then
  # expect script or bash commands
  set -- bash "$@"
fi

exec "$@"

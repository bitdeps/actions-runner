#!/bin/bash

# Start podman socket
podman system service --time=0 &

# Update and use the recent runner, it's preferrable for better API compatibility.
install-runner

if (! which "$1" 1>/dev/null 2>/dev/null ) && [ ! -x "$1" ]; then
  # expect script or bash commands
  set -- bash "$@"
fi

exec "$@"

#!/bin/bash
## Script performs several mitigations for actions runner: docker socket hardcode
##    1. /var/run/docker.sock hardcode
##    2. host empty directory creation for container volumes

set -e
: "${DOCKER_HOST:?must be provided}"

## debug script (if the variable actually passed through)
if [[ "$ACTIONS_STEP_DEBUG" == "true" ]]; then
  set -x
fi

CMD_ARGS=("$@")
podman=/usr/local/bin/podman

fix_run_create_cmds() {
  local -n aref=$1
  local hardcoded_docker_sock="/var/run/docker.sock:/var/run/docker.sock" host_path=""

  for ((i=0; i < ${#CMD_ARGS[@]}; i++)); do
    value="${CMD_ARGS[$i]}"

    # volume is met
    if [[ $value = "-v" ]]; then
      i=$((i+1)); value="${CMD_ARGS[$i]}"

      # skip docker volume passthrough
      if ( echo "$value" | grep -qw "$hardcoded_docker_sock" 2> /dev/null ); then continue; fi

      # precreate volume host directory
      aref+=(-v); 
      host_path="$(printf "%s" "$value" | sed 's/:.*//')"
      if [[ ! -a "$host_path" ]]; then
        mkdir -p "$host_path" || { >&2 echo "=> Unprivileged mode. You can't map non-existent or non-accessible paths ($host_path)"; exit 1; }
      fi
    fi
    aref+=("$value")
  done
}

cmd=""
for ((i=0; i < ${#CMD_ARGS[@]}; i++)); do
  if [[ "${CMD_ARGS["$i"]}" != "--"* ]]; then cmd="${CMD_ARGS["$i"]}"; break; fi
done

if [[ "$cmd" = "create" || "$cmd" = "run" ]]; then
  fix_run_create_cmds args
else
  args=("${CMD_ARGS[@]}")
fi

## run podman
$podman "${args[@]}"

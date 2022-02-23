#!/bin/bash

set -euo pipefail
REPO_NAME=${1}

check_required_environment() {
  # TODO: check for env variables
  local required_env=""

  for reqvar in $required_env; do
    if [ -z "${!reqvar:0:10}" ]; then
      raise "missing ENVIRONMENT VARIABLE ${reqvar}"
      return 1
    fi
  done
}

create_ghcr_secrets() {
    repo_name=${1##*/}
    gh_user=${2}
    gh_token=${3}
    local secret_args
    secret_args="lighthouse-techdocs-${repo_name}-secrets --docker-server=https://ghcr.io --docker-username=${gh_user} --docker-password=${gh_token}"
    kubectl create secret docker-registry ${secret_args}
}

run_main() {
    repo_name=${1}

    check_required_environment || exit 1
    create_ghcr_secrets "${repo_name}" "${GITHUB_USER}" "${GITHUB_TOKEN}" || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main "${REPO_NAME}" 
fi
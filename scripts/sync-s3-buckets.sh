#!/bin/bash

set -euo pipefail

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

create_sync_job() {

}

run_main() {
    service_account_name=${1}
    repo_name=${2}
    team_name=${3}
    kind=${4}
    name=${5}

    check_required_environment "${service_account_name}" "${repo_name}" "${team_name}" "${kind}" "${name}" || exit 1
    set_git_sync_args "${repo_name}" "${GITHUB_USER}" "${GITHUB_TOKEN}" || exit 1
    set_techdocs_args "${repo_name}" "${team_name}" "${kind}" "${name}" || exit 1
    create_job "${service_account_name}" "${repo_name}" || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main "${SERVICE_ACCOUNT_NAME}" 
fi
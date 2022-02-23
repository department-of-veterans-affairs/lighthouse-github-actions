#!/bin/bash

set -euo pipefail

REPO_NAME=${1}

check_required_environment() {
  local required_env=""

  for reqvar in $required_env; do
      if [ -z "${!reqvar:0:10}" ]; then
      raise "missing ENVIRONMENT VARIABLE ${reqvar}"
      return 1
      fi
  done
}

await_job() {
  repo=$1
  local job_name="lighthouse-techdocs-${repo}"
  while ! bash -c "kubectl get job.batch/${job_name} | grep \"1/1\"" > /dev/null 2>&1; do 
    kubectl logs -f -l app=${job_name}
    sleep 15;
    if kubectl get pods | grep "${job_name}" | grep -E "Error|BackOff"; then
        echo "Techdocs error!"
        kubectl logs -f -l app="${job_name}"
        clean_up "${repo}" "1"
    fi
    # if kubectl get pods | grep "${job_name}" | grep "BackOff"; then
    #     echo "Techdocs error!"
    #     kubectl logs -f -l app="${job_name}"
    #     clean_up
    # fi
  done

  echo "Techdocs Job complete"
}

clean_up() {
  repo_name=${1}
  exit_code=${2:-0}
  local job_name="lighthouse-techdocs-${repo}"
  echo "Cleaning up resources..."
  kubectl delete secret lighthouse-techdocs-${repo_name}-secrets
  kubectl delete job.batch/${job_name}
  echo "Clean up complete"
  exit ${exit_code}
}

run_main() {
  repo=${1##*/}

  await_job "${repo}" || exit 1
  clean_up "${repo}" "0" || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main "${REPO_NAME}"
fi
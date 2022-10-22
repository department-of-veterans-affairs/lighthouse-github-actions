#!/bin/bash

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

await_job() {
  repo=$1
  local job_name="td-${repo}-${branch}"
  while ! bash -c "kubectl get job.batch/${job_name} | grep \"1/1\"" > /dev/null 2>&1; do
    kubectl logs -f -l app=${job_name}
    sleep 15;
    if kubectl get pods | grep "${job_name}" | grep -E "Error|BackOff"; then
        echo "Techdocs error!"
        sleep 10;
        kubectl logs -f -l app="${job_name}"
        kubectl describe job.batch/${job_name}
        
        clean_up "1" "${repo}"
    fi
  done
  echo "Techdocs Job complete"
}

clean_up() {
  exit_code="${1:-$?}"
  repo_name=${2}

  local job_name="td-${repo}-${branch}"
  echo "Cleaning up resources..."
  kubectl delete secret td-${repo}-${branch}-secrets || true
  kubectl delete job.batch/${job_name} || true
  echo "Clean up complete"
  exit ${exit_code}
}

run_main() {
  repo=${1##*/}

  trap clean_up EXIT
  await_job "${repo}" || exit 1
  clean_up "0" "${repo}" || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main "${REPO_NAME}"
fi

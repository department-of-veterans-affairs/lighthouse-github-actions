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
  job_name="lighthouse-techdocs-${repo}"
  while ! bash -c "kubectl get job.batch/${job_name} | grep \"1/1\"" > /dev/null 2>&1; do 
    kubectl logs -f -l app=${job_name}
    sleep 15;
    if kubectl get pods | grep "${job_name}" | grep "0/1" | grep "Error"; then
        echo "Techdocs status: Error";
        kubectl get pods 
        kubectl logs -f -l app="${job_name}"
        exit 1;
    fi
    if kubectl get pods | grep "${job_name}" | grep "0/1" | grep "CrashLoopBackOff"; then
        echo "Techdocs status: CrashLoopBackOff";
        kubectl logs -f -l app="${job_name}"
        exit 1;
    fi
  done

}

run_main() {
  repo=${1##*/}

  await_job "${repo}" || exit 1
  echo "Techdocs Job complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main "${REPO_NAME}"
fi
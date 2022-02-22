#!/bin/bash

set -euo pipefail


check_required_environment() {
    local required_env=""

    for reqvar in $required_env; do
        if [ -z "${!reqvar:0:10}" ]; then
        raise "missing ENVIRONMENT VARIABLE ${reqvar}"
        return 1
        fi
    done
}

stream_output() {
  kubectl logs -f -l app=lighthouse-techdocs
}
await_job() {

while ! bash -c 'kubectl get job.batch/lighthouse-techdocs | grep "1/1"' > /dev/null 2>&1; do 
    kubectl logs -f -l app=lighthouse-techdocs
    sleep 15;
    if kubectl get pods | grep "lighthouse-techdocs" | grep "0/1" | grep "Error"; then
        echo "Techdocs error!";
        kubectl logs -f -l app=lighthouse-techdocs
        exit 1;
    fi
    if kubectl get pods | grep "lighthouse-techdocs" | grep "0/1" | grep "CrashLoopBackOff"; then
        echo "Techdocs error! CrashLoopBackOff";
        ku logs -f -l app=lighthouse-techdocs
        exit 1;
    fi
done

}

run_main() {
    await_job || exit 1
    echo "Techdocs Job complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main 
fi
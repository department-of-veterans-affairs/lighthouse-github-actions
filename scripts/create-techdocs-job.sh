#!/bin/bash

set -euo pipefail

SERVICE_ACCOUNT_NAME=${1}
REPO_NAME=${2}
TEAM_NAME=${3}
KIND=${4:-"Component"}
NAME=${5}

check_required_environment() {
  local required_env=""

  for reqvar in $required_env; do
    if [ -z "${!reqvar:0:10}" ]; then
      raise "missing ENVIRONMENT VARIABLE ${reqvar}"
      return 1
    fi
  done
}

create_job() {
    service_account_name=${1}
    repo_name=${2}
    team_name=${3}
    kind=${4:-"Component"}
    name=${5}

cat << EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
    name: create-techdocs
spec:
    ttlSecondsAfterFinished: 100
    template:
    metadata:
        labels:
            app: create-techdocs
    spec:
        serviceAccountName: ${service_account_name}
        initContainers:
        - name: git-sync
            image: k8s.gcr.io/git-sync:v3.1.5
            args:
                - "--repo=https://github.com/department-of-veterans-affairs/${repo_name}"
                - "--branch=main"
                - "--depth=1"
                - "--one-time"
            volumeMounts:
            - name: repo
                mountPath: /tmp/git
            resources:
            limits:
                cpu: 100m
                memory: 150Mi
        containers:
        - name: techdocs
            image: ghcr.io/department-of-veterans-affairs/embark-deployment/techdocs:latest
            imagePullPolicy: Always
            command: ['/bin/sh']
            args: 
                - -c
                - |
                    cd /tmp/git/lighthouse-embark
                    techdocs-cli generate --source-dir /tmp/git/lighthouse-embark --output-dir /tmp/git/techdocs/lighthouse-embark --no-docker -v
                    techdocs-cli publish --publisher-type awsS3 --storage-name embark-techdocs-storage --entity "${team_name}"/"${kind}"/"${name}" --directory /tmp/git/techdocs/lighthouse-embark 
                    scuttle python -V
            volumeMounts:
            - name: repo
                mountPath: /tmp/git/
            env:
            - name: ENVOY_ADMIN_API
            value: "http://127.0.0.1:15000"
            - name: ISTIO_QUIT_API
            value: "http://127.0.0.1:15020"
            - name: SCUTTLE_LOGGING
            value: "true"
            resources:
            limits:
                cpu: 500m
                memory: 1024Mi
        imagePullSecrets:
            - name: "dockerconfigjson-ghcr"
        restartPolicy: Never
        volumes:
        - name: repo
            emptyDir: {}
EOF
}

run_main() {
    service_account_name=${1}
    repo_name=${2}
    team_name=${3}
    kind=${4:-"Component"}
    name=${5}

    check_required_environment "${service_account_name}" "${repo_name}" "${team_name}" "${kind}" "${name}" || exit 1
    create_job "${service_account_name}" "${repo_name}" "${team_name}" "${kind}" "${name}" || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main "${SERVICE_ACCOUNT_NAME}" "${REPO_NAME}" "${TEAM_NAME}" "${KIND}" "${NAME}"
fi
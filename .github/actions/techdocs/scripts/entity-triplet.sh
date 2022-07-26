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

set_triplet() {
  local file="${BASE_PATH}/${FILE}"
  if [[ "${file}" == "./" ]]; then
    echo 'Checking for descriptor-file'
    file=$(ls | grep 'catalog-info')
  fi
  echo "$file"
  DEFAULT="default"
  NAMESPACE=$(cat "${file}" | yq .metadata.namespace)
  file_kind=$(cat "${file}" | yq .kind)
  name="$(cat "${file}" | yq .metadata.name)"
  if [[ "${NAMESPACE}" == "null" ]]; then
    echo "namespace=$DEFAULT" >> $GITHUB_ENV
  else
    echo "namespace=$NAMESPACE" >> $GITHUB_ENV
  fi
  if [[ -z "${KIND}" ]]; then
    echo "kind=$file_kind" >> $GITHUB_ENV
  else
    echo "kind=$KIND" >> $GITHUB_ENV
  fi
  if [[ -z "${NAME}" ]]; then
    echo "name=$name" >> $GITHUB_ENV
  else
    echo "name=$NAME" >> $GITHUB_ENV
  fi

}

run_main() {
  check_required_environment || exit 1
  set_triplet || exit 1

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main 
fi
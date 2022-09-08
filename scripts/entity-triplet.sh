#!/bin/bash

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
  if [[ -z "${FILE}" ]]; then
    echo 'Checking for descriptor-file'
    file_name+=$(ls ${BASE_PATH} | grep 'catalog-info')
  fi
  echo "$file_name"
  file_contents="$(cat "${file_name}" | yq -f backstage.io/techdocs-ref)"
  echo "$file_contents"
  DEFAULT="default"
  NAMESPACE=$(echo "${file_contents}" | yq -N '.metadata.namespace')
  file_kind=$(echo "${file_contents}" | yq -N '.kind')
  name="$(echo "${file_contents}" | yq -N '.metadata.name')"


  if [[ "${NAMESPACE}" == "null" ]]; then
    echo "namespace=$DEFAULT" >> $GITHUB_ENV
  else
    echo "$NAMESPACE" | while IFS= read -r each_namespace;
      do
        echo "namespace=$each_namespace" >> $GITHUB_ENV
      done
  fi
  if [[ -z "${KIND}" ]]; then
    echo "$file_kind" | while IFS= read -r each_kind;
      do
        echo "kind=$each_kind" >> $GITHUB_ENV
      done
  else
    echo "kind=$KIND" >> $GITHUB_ENV
  fi
  if [[ -z "${NAME}" ]]; then
    echo "$name" | while IFS= read -r each_name;
      do
        echo "name=$each_name" >> $GITHUB_ENV
      done
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
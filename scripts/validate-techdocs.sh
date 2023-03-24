#!/bin/bash

setup_mkdocs() {
  /bin/bash <(curl -s https://${TOKEN}@raw.githubusercontent.com/department-of-veterans-affairs/lighthouse-github-actions/main/scripts/setup_mkdocs.sh)
}

build_with_mkdocs() {
  echo "$(mkdocs build --config-file ./${REPO} ${ARGS} 2>&1)"
}

build_with_techdocs() {
  echo "$(techdocs-cli generate --no-docker -v)"
}

main() {
  local results
  setup_mkdocs || exit 1
  results+="$(build_with_mkdocs)"
  results+="$(build_with_techdocs)"
  # Need this for handling newlines for Github Action variables
  RESULTS="$(echo "${results}")"
  RESULTS="${RESULTS//'%'/'%25'}"
  RESULTS="${RESULTS//$'\n'/'%0A'}"
  RESULTS="${RESULTS//$'\r'/'%0D'}"
  echo "results=${RESULTS}" >> $GITHUB_OUTPUT
}

main

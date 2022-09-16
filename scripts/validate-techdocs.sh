#!/bin/bash

setup_mkdocs() {
  /bin/bash <(curl -s https://${TOKEN}@raw.githubusercontent.com/department-of-veterans-affairs/lighthouse-developer-portal/main/scripts/setup_mkdocs.sh)
}

build_with_mkdocs() {
  echo "$(mkdocs build --strict 2>&1)"
}

build_with_techdocs() {
  echo "$(techdocs-cli generate --no-docker -v)"
}

main() {
  local results
  setup_mkdocs || exit 1
  results+="$(echo -e "Running Mkdocs validation...\n")"
  results+="$(echo -e "Mkdocs results:\n")"
  results+="$(build_with_mkdocs)"
  results+="$(echo -e "Running techdocs-cli validation...\n")"
  results+="$(echo -e "Techdocs-cli results:\n")"
  results+="$(build_with_techdocs)"
  RESULTS="$(echo "${results}")"
  RESULTS="${RESULTS//'%'/'%25'}"
  RESULTS="${RESULTS//$'\n'/'%0A'}"
  RESULTS="${RESULTS//$'\r'/'%0D'}"
  echo "::set-output name=results::${RESULTS}"
}

main

#!/bin/bash

setup_mkdocs() {
  /bin/bash <(curl -s https://${TOKEN}@raw.githubusercontent.com/department-of-veterans-affairs/lighthouse-developer-portal/main/scripts/setup_mkdocs.sh)
}

build_with_mkdocs() {
  echo "`mkdocs build --strict 2>&1`"
}

build_with_techdocs() {
  build_techdocs=$(techdocs-cli generate --no-docker -v)
  echo "${build_techdocs}"
}

main() {
  local results
  setup_mkdocs || exit 1
  results+="$(build_with_mkdocs)"
  results+="$(build_with_techdocs)"
  echo "$results"
  echo "::set-output name=results::${results}"
}

main
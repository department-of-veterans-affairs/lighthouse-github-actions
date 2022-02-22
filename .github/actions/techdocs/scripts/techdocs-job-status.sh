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




run_main() {
    
    echo "Techdocs Job complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main 
fi
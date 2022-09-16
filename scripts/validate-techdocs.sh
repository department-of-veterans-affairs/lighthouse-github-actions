#!/bin/bash

testing_workflow() {
  echo "I'm a real workflow!"
}

main() {
  testing_workflow || exit 1
}

main
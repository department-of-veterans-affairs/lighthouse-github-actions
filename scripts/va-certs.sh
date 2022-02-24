#!/bin/bash

# Script to download VA certs from public github repo
# Running the script in the github actions was buggy(connection reset errors)
# Opted to just keep certs in a local cert directory

set -euo pipefail
GH_TOKEN=${1:-"$GITHUB_TOKEN"}

CA_CERTS=(
  VA-Internal-S2-RCA1-v1.cer
  VA-Internal-S2-ICA4.cer
  VA-Internal-S2-ICA5.cer
  VA-Internal-S2-ICA6.cer
  VA-Internal-S2-ICA7.cer
  VA-Internal-S2-ICA8.cer
  VA-Internal-S2-ICA9.cer
  VA-Internal-S2-ICA10.cer
  VA-Internal-S2-ICA1-v1.cer
  VA-Internal-S2-ICA2-v1.cer
  VA-Internal-S2-ICA3-v1.cer
)

p_dir=$(pwd)
ANCHORS="$p_dir/certs"
mkdir -p $ANCHORS

for CERT in ${CA_CERTS[@]}
do
  echo "Downloading $CERT"
  curl \
  -H "Authorization: token $GH_TOKEN" \
  -H 'Accept: application/vnd.github.v3.raw' \
  -O \
  -L "https://api.github.com/repos/department-of-veterans-affairs/platform-va-ca-certificate/contents/$CERT" \

  OUT=$ANCHORS/${CERT##*/}
  mv $CERT $OUT
done
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

create_job() {
  cat << EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: techdocs-$REPOSITORY
spec:
  ttlSecondsAfterFinished: 100
  template:
    metadata:
      labels:
        app: techdocs-$REPOSITORY
        sidecar.istio.io/inject: "false"
    spec:
      serviceAccountName: $SERVICE_ACCOUNT_NAME
      initContainers:
      - name: git-sync
        image: ghcr.io/department-of-veterans-affairs/lighthouse-developer-portal/git-sync:23.02.3
        command: ['/git-sync']
        args:
          - --repo=https://github.com/$REPOSITORY
          - --branch=$BRANCH
          - --depth=1
          - --one-time
          - --username=$GITHUB_USER
          - --password=$GITHUB_TOKEN
          - --root=/tmp/git
        volumeMounts:
          - name: repo
            mountPath: /tmp/git
        resources:
          limits:
            cpu: 300m
            memory: 450Mi
      containers:
      - name: techdocs
        image: ghcr.io/department-of-veterans-affairs/lighthouse-developer-portal/techdocs:9d372eafca1258904d4a589c61f07726c3dd9f6f
        imagePullPolicy: Always
        command: ['/bin/sh']
        args:
        - -c
        - |
          cd /tmp/git/$REPOSITORY || exit 1
          sed -i 's/backstage.io\/techdocs-ref: dir:.\//backstage.io\/techdocs-ref: dir:./g' catalog-info.yaml
          techdocs-cli generate \
            --source-dir /tmp/git/$REPOSITORY \
            --output-dir /tmp/git/techdocs/$REPOSITORY \
            --no-docker \
            -v \
            --legacyCopyReadmeMdToIndexMd
          techdocs-cli publish \
            --publisher-type awsS3 \
            --storage-name $S3_BUCKET_NAME \
            --entity $NAMESPACE/$KIND/$NAME \
            --directory /tmp/git/techdocs/$REPOSITORY
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
        - name: docker-registry-creds
      restartPolicy: Never
      volumes:
      - name: repo
        emptyDir: {}
EOF
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  check_required_environment \
    "${BRANCH}" \
    "${GITHUB_USER}" \
    "${GITHUB_TOKEN}" \
    "${KIND}" \
    "${NAME}" \
    "${NAMESPACE}" \
    "${REPOSITORY}" \
    "${S3_BUCKET_NAME}" \
    "${SERVICE_ACCOUNT_NAME}" \
    || exit 1
  create_job || exit 1
fi

# lighthouse-github-actions
Custom GitHub Actions for Lighthouse Internal Developer Portal

# Techdocs Action

This action creates a [Kubernetes Job](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/example-techdocs-job.yaml) that will generate and publish your Techdocs for the Lighthouse Internal Developer Portal.

# Overview
The Kubernetes Job consists of two containers:  a [git-sync](https://github.com/kubernetes/git-sync) container and a `Techdocs` container<sup>[1](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/pkgs/container/lighthouse-github-actions%2Ftechdocs)[2](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/.techdocscontainer/base.Dockerfile)</sup>. The `git-sync` container is an initContainer that pulls a git repository to a shared volume so the Techdocs container has a copy of all markdown files. The `Techdocs` container then uses the [Techdocs-cli](https://backstage.io/docs/features/techdocs/cli) to generate and publish your documentation to the Lighthouse S3 bucket. 


# Usage

<!-- start usage -->
```yaml
- name: Create Techdocs Job
  uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs@main
  with:
    # Kubernetes Context for the cluster the job will run on. Uses azure/k8s-set-context@v1
    # *Required*
    kubeconfig: ''

    # Kubernetes Namespace that the Techdocs job will be created in
    # Default: 'default'
    kube_namespace: ''

    # ServiceAccountName used by the job; needed for credentials to connect to S3 bucket.
    # *Required*
    serviceAccountName: ''

    # Owner and repository where the documentation lives (e.g. department-of-veterans-affairs/lighthouse-embark)
    # Default: ${{ github.repository }}
    repository: ''

    # Name of Entity descriptor file; used to create Entity path (i.e. namespace/kind/name)
    # Default: 'catalog-info.yaml'
    descriptor-file:

    # Team name; used to create path to entity's documentation 
    # Default: Value of the 'metadata.namespace' field from Entity descriptor file
    # Required IF the Entity descriptor file does not define the 'metadata.namespace'
    team-name: ''

    # Entity's Kind; used to create path to entity's documentation 
    # Default: Value of the 'Kind' field from Entity descriptor file
    kind: ''

    # Entity's name; used to create path to entity's documentation 
    # Default: Value of the 'metadata.name' field from Entity descriptor file
    name: ''

    # Username used for GHCR authentication
    # Default: ${{ github.repository_owner }}
    username: ''

    # Token used for GHCR authentication
    # Default: ${{ github.token }}
    token: ''

```
<!-- end usage -->

# Scenarios
- [Add action to existing Github Workflow](#Add-action-to-existing-Github-Workflow)
- [Create standlone workflow](#Create-standalone-workflow)

## Add action to existing Github Workflow
```yaml
TODO
```

## Create standalone workflow

```yaml
# Example workflow
name: Build and publish deployment repo docs 

on:
  push:
    branches: [main]
    paths: ['docs/*']
  workflow_dispatch:

jobs:
  build-and-publish-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Create Techdocs Job
        uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs@main
        with:
          kubeconfig: ${{ secrets.KUBE_CONFIG }}
          namespace: "lighthouse-bandicoot-dev"
          serviceAccountName: "bandicoot-sa"
```



# Lighthouse Hub Github Actions

Github Actions that help teams use the Lighthouse Hub

## TechDocs Action

This action creates a [Kubernetes Job](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/scripts/create-techdocs-job.sh) that will generate and publish your TechDocs for the Lighthouse Hub.

### Overview

The Kubernetes Job consists of two containers: a [git-sync](https://github.com/kubernetes/git-sync) container and a [TechDocs](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/techdocs/Dockerfile) container. The `git-sync` container is an initContainer that pulls a git repository to a shared volume so the TechDocs container has a copy of all markdown files. The `TechDocs` container then uses the [TechDocs-cli](https://backstage.io/docs/features/techdocs/cli) to generate and publish your documentation to the Lighthouse S3 bucket.

### TechDocs Prerequisites

The root directory of your repository contains:

- [catalog-info.yaml](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/catalog-info.yaml) with a [backstage.io/techdocs-ref](https://backstage.io/docs/features/software-catalog/well-known-annotations#backstageiotechdocs-ref) annotation
- [mkdocs.yaml](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/mkdocs.yml) configuration file
- [docs](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/tree/main/docs) directory where all your documentation lives

More info about [Entity Descriptor files](https://backstage.io/docs/features/software-catalog/descriptor-format#overall-shape-of-an-entity)

### Usage

<!-- start usage -->

```yaml
- name: Create TechDocs Job
  uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs-webhook@latest
  with:
    # Owner and repository where the documentation lives (e.g. department-of-veterans-affairs/lighthouse-developer-portal)
    # Default: ${{ github.repository }}
    repository: ''

    # Repo branch to validate/publish documentation; use ${{ github.ref_name }} to specify the branch used for the workflow dispatch
    # Defaults to repository's default branch
    branch: ''

    # Name of Entity descriptor file; used to create Entity path (i.e. namespace/kind/name)
    # Default: 'catalog-info.yaml'
    descriptor-file: ''

    # Personal Access Token used for TechDocs Webhook
    # Scopes: Repo
    token: ''

    # Deploy to gh-pages; only include if you want to publish docs externally to GitHub (github.io)
    # Default: false
    gh-pages: true|false

    # Flag for enabling/disabling TechDocs for production
    # Default: true
    enable-production: true|false
```

<!-- end usage -->

### Examples

- [Create standlone workflow with Github Actions](#create-standalone-workflow-with-github-actions)

#### Create standalone workflow with Github Actions

```yaml
# Example workflow
name: Publish Documentation
on:
  push:
    branches: [main]
    paths: ['**/docs/*', '**/mkdocs.yaml'] # Additionally, using '**/*.md' will check all '.md' files for changes including in /docs
jobs:
  create-techdocs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Techdocs webhook
        uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs-webhook@main
        with:
          repository: ${{ github.repository }}
          token: ${{ secrets.PAT }}
          branch: ${{ github.ref_name }}
```

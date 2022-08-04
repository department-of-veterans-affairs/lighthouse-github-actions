# Lighthouse Internal Developer Hub Github Actions

Github Actions that help teams use the Ligthhouse Internal Developer Hub

## Techdocs Action

This action creates a [Kubernetes Job](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/example-techdocs-job.yaml) that will generate and publish your Techdocs for the Lighthouse Internal Developer Portal.

### Overview

The Kubernetes Job consists of two containers:  a [git-sync](https://github.com/kubernetes/git-sync) container and a [Techdocs](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/techdocs/Dockerfile.techdocs) container. The `git-sync` container is an initContainer that pulls a git repository to a shared volume so the Techdocs container has a copy of all markdown files. The `Techdocs` container then uses the [Techdocs-cli](https://backstage.io/docs/features/techdocs/cli) to generate and publish your documentation to the Lighthouse S3 bucket.

### Techdocs Prerequisites

The root directory of your repository contains:

* [catalog-info.yaml](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/catalog-info.yaml) with a [backstage.io/techdocs-ref](https://backstage.io/docs/features/software-catalog/well-known-annotations#backstageiotechdocs-ref) annotation
* [mkdocs.yaml](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/mkdocs.yml) configuration file
* [docs](https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/tree/main/docs) directory where all your documentation lives

More info about [Entity Descriptor files](https://backstage.io/docs/features/software-catalog/descriptor-format#overall-shape-of-an-entity)

### Usage

<!-- start usage -->
```yaml
- name: Create Techdocs Job
  uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs@main
  with:
    # Owner and repository where the documentation lives (e.g. department-of-veterans-affairs/lighthouse-developer-portal)
    # Default: ${{ github.repository }}
    # Required: true
    repository: ''

    # Name of Entity descriptor file; used to create Entity path (i.e. namespace/kind/name)
    # Default: 'catalog-info.yaml'
    # Required: false
    descriptor-file: ''

    # Personal Access Token used for Techdocs Webhook
    # Scopes: Repo
    # Required: true
    token: ''

```
<!-- end usage -->

### Examples

* [Create standlone workflow with Github Actions](#Create-standalone-workflow-with-github-actions)

#### Create standalone workflow with Github Actions

```yaml
# Example workflow
name: Publish Documentation
on:
  push:
    branches: [main]
    paths: ['**/docs/*', '**/mkdocs.yaml']
jobs:
  create-techdocs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Techdocs webhook
        uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs-webhook@main
        with:
          repository: ${{ github.repository }}
          token: ${{ secrets.WEBHOOK_PAT }}
```

## Github Pages Action

This action uses Mkdocs to deploy Github Pages documentation compatible with Backstage TechDocs & PlantUML.

### Example Usage

```yaml
name: Publish Documentation
on:
  push:
    branches: [main]
    paths: ['**/*.md', '**/mkdocs.yaml']
  workflow_dispatch:
jobs:
  deploy-gh-pages:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Publish to github pages
        uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/gh-pages@main
```

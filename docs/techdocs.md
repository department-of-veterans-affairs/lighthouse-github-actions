# Techdocs Action

This action creates a [Kubernetes Job](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/example-techdocs-job.yaml) that will generate and publish your Techdocs for the Lighthouse Internal Developer Portal.

# Overview
The Kubernetes Job consists of two containers:  a [git-sync](https://github.com/kubernetes/git-sync) container and a `Techdocs` container<sup>[1](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/pkgs/container/lighthouse-github-actions%2Ftechdocs)[2](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/.techdocscontainer/base.Dockerfile)</sup>. The `git-sync` container is an initContainer that pulls a git repository to a shared volume so the Techdocs container has a copy of all markdown files. The `Techdocs` container then uses the [Techdocs-cli](https://backstage.io/docs/features/techdocs/cli) to generate and publish your documentation to the Lighthouse S3 bucket.

## Techdocs Prerequisites
The root directory of your repository contains:
- [x] a <a href="https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/catalog-info.yaml">`catalog-info.yaml`</a> with a <a href="https://backstage.io/docs/features/software-catalog/well-known-annotations#backstageiotechdocs-ref">backstage.io/techdocs-ref</a> annotation
- [x] a <a href="https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/blob/main/mkdocs.yml">`mkdocs.yaml`</a> configuration file
- [x] a <a href="https://github.com/department-of-veterans-affairs/lighthouse-developer-portal/tree/main/docs">`docs`</a> directory where all your documentation lives

More info about [Entity Descriptor files](https://backstage.io/docs/features/software-catalog/descriptor-format#overall-shape-of-an-entity)

# Usage

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

    # Namespace of the Catalog Entity in the Lighthouse Developer Portal
    # Default: 'default'
    # Note: This value should match the 'metadata.namespace' field in the Entity descriptor file.
    # The 'metadata.namespace' field is arbitrary and does not correspond to an actual Kubernetes namespace.
    # It is recommended to use your team name for the 'metadata.namespace' field to prevent collisions with
    # Catalog Entities from other teams.
    namespace: ''

    # Personal Access Token used for Techdocs Webhook
    # Scopes: Repo
    # Required: true
    token: ''

```
<!-- end usage -->

# Examples
- [Create standlone workflow](#Create-standalone-workflow)

## Create standalone workflow

```yaml
# Example workflow
name: Publish Documentation
on:
  push:
    branches: [main]
    paths: ['docs/*']
jobs:
  create-techdocs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Techdocs webhook
        uses: department-of-veterans-affairs/lighthouse-github-actions/.github/actions/techdocs-webhook@main
        with:
          repository: ${{ github.repository }}
          descriptor-file: 'catalog-info.yaml'
          namespace: 'lighthouse-bandicoot'
          token: ${{ secrets.WEBHOOK_PAT }}
```

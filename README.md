# lighthouse-github-actions
Custom GitHub Actions for Lighthouse Internal Developer Portal


# Techdocs Action

This action creates a [Kubernetes Job](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/example-techdocs-job.yaml) that will generate and publish your Techdocs for the Lighthouse Internal Developer Portal.

# Overview
The Kubernetes Job consists of two containers:  a [git-sync](https://github.com/kubernetes/git-sync) container and this techdocs container<sup>[1](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/pkgs/container/lighthouse-github-actions%2Ftechdocs)[2](https://github.com/department-of-veterans-affairs/lighthouse-github-actions/blob/main/.techdocscontainer/base.Dockerfile)</sup>. The `git-sync` container is an initContainer that uses the `git` cli to pull source code from your repository. The `techdocs` container then uses the [Techdocs-cli](https://backstage.io/docs/features/techdocs/cli) to generate and publish your documentation to the Lighthouse S3 bucket. 




# Usage

<!-- start usage -->
```yaml
- name: Check out internal repository
  uses: actions/checkout@v2
  with:
    repository: department-of-veterans-affairs/lighthouse-github-actions
    token: ${{ secrets.GH_TOKEN }}
    path: ./.github/actions/lighthouse-github-actions
- name: Create Techdocs Job
  uses: ./.github/actions/lighthouse-github-actions/.github/actions/techdocs
  with:
    # Kubernetes Context for the cluster the job will run on. Uses azure/k8s-set-context@v1
    # *Required*
    # Default: ${{ secrets.KUBE_CONFIG }}
    kubeconfig: ''

    # Namespace that the job will run in. 
    # Default: "default"
    namespace: ''

    # ServiceAccountName used by the job. Needed for credentials to connect to S3 bucket.
    # *Required*
    serviceAccountName: ''

    # Repository name where the documentation lives.
    # Default: ${{ github.repository }}
    repository: ''

    # Team name; used to create path to entity's documentation 
    # *Required*
    team-name: ''

    # Entity's Kind; used to create path to entity's documentation 
    # *Required*
    kind: ''

    # Entity's name; used to create path to entity's documentation 
    # *Required*
    name: ''

```
<!-- end usage -->

# Scenarios
- [Add action to existing Github Workflow](#Add-action-to-existing-Github-Workflow)
- [Add action to existing Github Workflow](#Create-Techdocs-for-Private-Repository)


## Add action to existing Github Workflow

```yaml
TODO
```

## Add action to existing Github Workflow

```yaml
TODO
```

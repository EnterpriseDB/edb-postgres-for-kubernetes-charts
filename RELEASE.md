# EDB Postgres for Kubernetes Operator release procedure

## Required tools:

- [helm-schemagen](https://github.com/karuppiah7890/helm-schema-gen): to generate the JSON schema for the chart's values
- [helm-docs](https://github.com/norwoodj/helm-docs): to generate the chart's README.md

## Release Checklist:

- [] Update the documentation: `make docs`
- [] Update the schema: `make schema`

## Steps:

The following steps assume version 0.2.0 as the one to be released. Alter the
instructions accordingly.

1. Create branch `release/v0.2.0`
1. Approve the PR that is automatically generated.
1. The tag 0.2.0 will be created when the PR is merged.
1. The helm chart will be automatically added to the chart index.

To check the chart was updated correctly, run:
```bash
helm repo add edb-pg4k https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts/
# or "helm repo update" if already added
helm search repo edb-pg4k
```
and you should see the latest version available.

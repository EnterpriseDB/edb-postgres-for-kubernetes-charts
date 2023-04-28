# How To Release

**IMPORTANT** we should run the below procedures against the latest point
release of the EDB Postgres for Kubernetes operator. I.e. even if we have several release branches, we will only target the most advanced point
release (e.g. 1.17.1)

## How to release the edb-postgres-for-kubernetes chart

In order to create a new release of the `edb-postgres-for-kubernetes` chart,
follow these steps:

1. take note of the current value of the release: see `.version`
   in `charts/edb-postgres-for-kubernetes/Chart.yaml`
1. decide which version to create, depending on the kind of jump of the
   EDB Postgres for Kubernetes (EPK) release, following semver semantics.
   For this document, let's call it `X.Y.Z`
1. create a branch named `release/vX.Y.Z` and switch to it
1. update the `.version` in the [Chart.yaml](./charts/edb-postgres-for-kubernetes/Chart.yaml) file to `"X.Y.Z"`
1. update everything else as required, e.g. if releasing due to a new
   cloudnative-pg version being released, you might want to update the
   following:
   1. `.appVersion` in the [Chart.yaml](./charts/edb-postgres-for-kubernetes/Chart.yaml) file
   1. [crds.yaml](./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml), whose
       content can be built using [kustomize](https://kustomize.io/) from the
       cloudnative-pg repo using kustomize
       [remoteBuild](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/remoteBuild.md)
       running: `kustomize build
       https://github.com/EnterpriseDB/cloud-native-postgres/tree/release-1.20/config/helm/\?ref=v1.20.0`,
       **take care to set the correct release branch and version as ref**
        (v1.20.0 in the example
       command). \
       It might be easier to run `kustomize build config/helm` from the
      `cloudnative-pg` repo, with the desired release branch checked out, and
      copy the result to `./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml`.
   1. NOTE: please keep the guards for `.Values.crds.create`, i.e.
      `{{- if .Values.crds.create }}` and `{{- end }}` after you copy the CRD
      into `templates/crds/crds.yaml`.
   1. to update the files in the
       [templates](./charts/edb-postgres-for-kubernetes/templates) directory, you can diff
       the previous EPK release yaml against the new one, to find what
       should be updated (e.g. `vimdiff
       https://raw.githubusercontent.com/EnterpriseDB/cloud-native-postgres/main/releases/postgresql-operator-1.15.0.yaml
       https://raw.githubusercontent.com/EnterpriseDB/cloud-native-postgres/main/releases/postgresql-operator-1.15.1.yaml`) \
       Or, from the `cloudnative-pg` repo, with the desired release branch checked out,
       `vimdiff releases/postgresql-operator-1.15.0.yaml releases/postgresql-operator-1.15.1.yaml`
   1. update [values.yaml](./charts/edb-postgres-for-kubernetes/values.yaml) if needed
   1. NOTE: updating `values.yaml` just for the EPK  verision may not be
      necessary, as the value should default to the `appVersion` in `Chart.yaml`
1. run `make docs schema` to regenerate the docs and the values schema in case it is needed
1. `git commit -S -s -m "Release vX.Y.Z" --edit` and add all
     the informations you wish below the commit message.
1. `git push --set-upstream origin release/vX.Y.Z`
1. a PR named `Release vX.Y.Z` will be automatically created
1. wait for all the checks to pass
1. two approvals are required in order to merge the PR, if you are a
     maintainer approve the PR yourself and ask for another approval, otherwise
     ask for two approvals directly.
1. merge the pr squashing all commits and **taking care to keep the commit
     message to be `Release vX.Y.Z`**
1. a tag `vX.Y.Z` will be automatically created by an action,
     which will ten trigger the release action, check they both are successful.
1. once done you should be able to run helm repo `helm repo add edb-pg4k https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts/; helm repo update; helm search repo edb-pg4k` and be able to see the new version `vX.Y.Z` as `CHART VERSION`

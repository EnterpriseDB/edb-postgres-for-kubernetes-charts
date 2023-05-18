# How To Release

**IMPORTANT**: We should run the below procedures against the latest point
release of each EDB operator. I.e. even if we have several supported release branches, we
will only target the most advanced point release.

## How to release the edb-postgres-for-kubernetes chart

In order to create a new release of the `edb-postgres-for-kubernetes` chart,
follow these steps:

1. take note of the current value of the release: see `.version`
   in `charts/edb-postgres-for-kubernetes/Chart.yaml`
1. decide which version to create, depending on the kind of jump of the
   EDB Postgres for Kubernetes (EPK) release, following semver semantics.
   For this document, let's call it `X.Y.Z`
1. create a branch named `release/edb-postgres-for-kubernetes-vX.Y.Z` and switch to it
1. update the `.version` in `charts/edb-postgres-for-kubernetes/Chart.yaml` to `"X.Y.Z"`
1. update everything else as required:
   1. `.appVersion` in `charts/edb-postgres-for-kubernetes/Chart.yaml`
   1. CRDs (`charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml`), whose
      content can be built using [kustomize](https://kustomize.io/) from the
      [EPK repo](https://github.com/EnterpriseDB/cloud-native-postgres) by
      running `kustomize build config/helm` with the desired release branch checked out.
      Then copy the result to `./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml`.
      **NOTE**: please keep the guards for `.Values.crds.create` (i.e.
      `{{- if .Values.crds.create }}` and `{{- end }}`) and other possible template
      variables after you copy the CRD into `templates/crds/crds.yaml`.
   1. to update the files in the
       `charts/edb-postgres-for-kubernetes/templates` directory, you can diff
       the previous EPK release yaml against the new one, to find what
       should be updated (e.g. on the EPK repo, check out the desired release
       branch and run:
      `vimdiff diff releases/postgresql-operator-1.19.0.yaml releases/postgresql-operator-1.20.0.yaml`).
   1. update `charts/edb-postgres-for-kubernetes/values.yaml` if needed
      **NOTE**: updating `values.yaml` just for the EPK version may not be
      necessary, as the value should default to the `appVersion` in `Chart.yaml`
1. run `make docs schema` to regenerate the docs and the values schema in case it is needed
1. `git commit -S -s -m "Release edb-postgres-for-kubernetes-vX.Y.Z" --edit` and add all
     the informations you wish below the commit message.
1. `git push --set-upstream origin release/edb-postgres-for-kubernetes-vX.Y.Z`
1. a PR named `Release edb-postgres-for-kubernetes-vX.Y.Z` will be automatically created
1. wait for all the checks to pass
1. two approvals are required in order to merge the PR, if you are a
     maintainer approve the PR yourself and ask for another approval, otherwise
     ask for two approvals directly.
1. merge the pr squashing all commits and **taking care to keep the commit
     message to be `Release edb-postgres-for-kubernetes-vX.Y.Z`**
1. a tag `edb-postgres-for-kubernetes-vX.Y.Z` will be automatically created by an action,
     which will then trigger the release action. Check that they both complete successfully.
1. once done you should be able to run helm repo `helm repo add edb https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts/; helm repo update; helm search repo edb` and be able to see the new version `edb-postgres-for-kubernetes-vX.Y.Z` as `CHART VERSION`


## How to release the edb-postgres-distributed-for-kubernetes chart

In order to create a new release of the `edb-postgres-distributed-for-kubernetes` chart,
follow these steps:

1. take note of the current value of the release: see `.version`
   in `charts/edb-postgres-distributed-for-kubernetes/Chart.yaml`
1. decide which version to create, depending on the kind of jump of the
   PG4K-PGD release, following semver semantics.
   For this document, let's call it `X.Y.Z`
1. create a branch named `release/edb-postgres-distributed-for-kubernetes-vX.Y.Z` and switch to it
1. update the `.version` in `charts/edb-postgres-distributed-for-kubernetes/Chart.yaml` to `"X.Y.Z"`
1. update everything else as required:
   1. `.appVersion` in `charts/edb-postgres-distributed-for-kubernetes/Chart.yaml`
   1. `.dependencies` versions in `charts/edb-postgres-distributed-for-kubernetes/Chart yaml`
   1. CRDs (`charts/edb-postgres-distributed-for-kubernetes/templates/crds/crds.yaml`), whose
      content can be built using [kustomize](https://kustomize.io/) from the
      [PG4K-PGD repo](https://github.com/EnterpriseDB/pg4k-pgd) by
      running `kustomize build config/helm` with the desired release branch checked out.
      Then copy the result to `./charts/edb-postgres-distributed-for-kubernetes/templates/crds/crds.yaml`.
      **NOTE**: please keep the guards for `.Values.crds.create` (i.e.
      `{{- if .Values.crds.create }}` and `{{- end }}`) and other possible template
      variables after you copy the CRD into `templates/crds/crds.yaml`.
   1. to update the files in the
       `charts/edb-postgres-distributed-for-kubernetes/templates` directory, you can diff
       the previous PG4K-PGD release yaml against the new one, to find what
       should be updated (e.g. on the PG4K-PGD repo, check out the desired release
       branch and run:
      `vimdiff diff releases/pg4k-pgd-0.5.0.yaml releases/pg4k-pgd-0.6.0.yaml`).
   1. update `charts/edb-postgres-distributed-for-kubernetes/values.yaml` if needed
      **NOTE**: updating `values.yaml` just for the PG4K-PGD version may not be
      necessary, as the value should default to the `appVersion` in `Chart.yaml`

From here onward, you can follow the steps of the [EPK Release](#how-to-release-the-edb-postgres-for-kubernetes-chart), starting from `point 6`.

**IMPORTANT**: take care to replace `edb-postgres-for-kubernetes` with `edb-postgres-distributed-for-kubernetes` accordingly
before executing the commands.

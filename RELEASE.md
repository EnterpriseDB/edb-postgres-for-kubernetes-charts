# Release Process

This repo contains two helm charts: [edb-postgres-for-kubernetes](./charts/edb-postgres-for-kubernetes)
and [edb-postgres-distributed-for-kubernetes](./charts/edb-postgres-distributed-for-kubernetes).
Both the charts are available through a single [repository](http://enterprisedb.github.io/edb-postgres-for-kubernetes-charts),
but should be released separately as their versioning might be unlinked, and the
latter depends on the former.

**IMPORTANT**: We should run the below procedures against the latest point
release of each EDB operator. I.e. even if we have several supported release
branches, we will only target the most advanced point release.

## Charts

1. [Releasing the `edb-postgres-for-kubernetes` chart](#releasing-the-edb-postgres-for-kubernetes-chart)
2. [Releasing the `edb-postgres-distributed-for-kubernetes` chart](#releasing-the-edb-postgres-distributed-for-kubernetes-chart)

## Releasing the `edb-postgres-for-kubernetes` chart

In order to create a new release of the `edb-postgres-for-kubernetes` chart,
follow these steps:

1. Take note of the current value of the release: see `.version`
    in `charts/edb-postgres-for-kubernetes/Chart.yaml`

    ```bash
    OLD_VERSION=$(yq -r '.version' charts/edb-postgres-for-kubernetes/Chart.yaml)
    OLD_PG4K_VERSION=$(yq -r '.appVersion' charts/edb-postgres-for-kubernetes/Chart.yaml)
    echo $OLD_VERSION
    ```

2. Decide which version to create, depending on the kind of jump of the
    EDB Postgres for Kubernetes (PG4K) release, following semver semantics.
    For this document, let's call it `X.Y.Z`

    ```bash
    NEW_VERSION="X.Y.Z"
    ```

3. Create a branch named `release/edb-postgres-for-kubernetes-vX.Y.Z`
    and switch to it

    ```bash
    git switch --create release/edb-postgres-for-kubernetes-v$NEW_VERSION
    ```

4. Update the `.version` in `charts/edb-postgres-for-kubernetes/Chart.yaml` to `"X.Y.Z"`

    ```bash
    sed -i -E "s/^version: \"([0-9]+.?)+\"/version: \"$NEW_VERSION\"/" charts/edb-postgres-for-kubernetes/Chart.yaml
    ```

5. Update everything else as required, if releasing due to a new
    `edb-postgres-for-kubernetes` version being released, you might
    want to:

    1. Find the latest `edb-postgres-for-kubernetes` version by running:

        ```bash
        NEW_PG4K_VERSION=$(
          gh api "https://api.github.com/repos/EnterpriseDB/cloud-native-postgres/tags" | \
          jq -r '.[0].name | ltrimstr("v")')
        echo $NEW_PG4K_VERSION
        ```

    2. Update `.appVersion` in [Chart.yaml](./charts/edb-postgres-for-kubernetes/Chart.yaml)
        file

        ```bash
        sed -i -E "s/^appVersion: \"([0-9]+.?)+\"/appVersion: \"$NEW_PG4K_VERSION\"/" \
          charts/edb-postgres-for-kubernetes/Chart.yaml
        ```

    3. Update [crds.yaml](./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml),
        which can be built using
        [kustomize](https://kustomize.io/) from the [PG4K repo](https://github.com/EnterpriseDB/cloud-native-postgres)
        using kustomize [remoteBuild](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/remoteBuild.md)
        running:

        ```bash
        echo '{{- if .Values.crds.create }}' > ./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml
        kustomize build https://github.com/EnterpriseDB/cloud-native-postgres/config/helm/\?ref\=v$NEW_PG4K_VERSION >> ./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml
        echo '{{- end }}' >> ./charts/edb-postgres-for-kubernetes/templates/crds/crds.yaml
        ```

    4. To update the files in the [templates](./charts/edb-postgres-for-kubernetes/templates) directory, you can diff the previous
        PG4K release yaml against the new one, to find what should be updated. E.g.,

        ```bash
        vimdiff \
          "https://get.enterprisedb.io/cnp/postgresql-operator-${OLD_PG4K_VERSION}.yaml" \
          "https://get.enterprisedb.io/cnp/postgresql-operator-${NEW_PG4K_VERSION}.yaml"
        ```

        Or from the `cloudnative-pg` repo, with the desired release branch
        checked out:

        ```bash
        vimdiff postgresql-operator-${OLD_PG4K_VERSION}.yaml postgresql-operator-${NEW_PG4K_VERSION}.yaml
        ```

    5. Update [values.yaml](./charts/edb-postgres-for-kubernetes/values.yaml) if needed
    6. NOTE: updating `values.yaml` just for the PG4K version may not be
        necessary, as the value should default to the `appVersion` in `Chart.yaml`
6. Run `make docs schema` to regenerate the docs and the values schema in case it is needed

    ```bash
    make docs schema
    ```

7. Commit and add the relevant information you wish in the commit message.

    ```bash
    git add -p .
    git commit -S -s -m "Release edb-postgres-for-kubernetes-v$NEW_VERSION" --edit
    ```

8. Push the new branch

    ```bash
    git push --set-upstream origin release/edb-postgres-for-kubernetes-v$NEW_VERSION
    ```

9. A PR named `Release edb-postgres-for-kubernetes-vX.Y.Z` should be
    automatically created
10. Wait for all the checks to pass
11. Two approvals are required in order to merge the PR, if you are a
    maintainer approve the PR yourself and ask for another approval,
    otherwise ask for two approvals directly.
12. Merge the PR squashing all commits and **taking care to keep the commit message to be
    `Release edb-postgres-for-kubernetes-vX.Y.Z`**
13. A release `edb-postgres-for-kubernetes-vX.Y.Z` should be automatically created by an action, which will then trigger the release
    action. Verify they both are successful.
14. Once done you should be able to run:

    ```bash
    helm repo add edb https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts
    helm repo update
    helm search repo edb
    ```

    and be able to see the new version `X.Y.Z` as `CHART VERSION` for `edb-postgres-for-kubernetes`

## Releasing the `edb-postgres-distributed-for-kubernetes` chart

In order to create a new release of the `edb-postgres-distributed-for-kubernetes` chart,
follow these steps:

1. Take note of the current value of the release: see `.version`
    in `charts/edb-postgres-distributed-for-kubernetes/Chart.yaml`

    ```bash
    OLD_VERSION=$(yq -r '.version' charts/edb-postgres-distributed-for-kubernetes/Chart.yaml)
    OLD_PG4DK_VERSION=$(yq -r '.appVersion' charts/edb-postgres-distributed-for-kubernetes/Chart.yaml)
    echo $OLD_VERSION
    ```

2. Decide which version to create, depending on the kind of jump of the
    EDB Postgres for Kubernetes (PG4K) release, following semver semantics.
    For this document, let's call it `X.Y.Z`

    ```bash
    NEW_VERSION="X.Y.Z"
    ```

3. Create a branch named `release/edb-postgres-distributed-for-kubernetes-vX.Y.Z`
    and switch to it

    ```bash
    git switch --create release/edb-postgres-distributed-for-kubernetes-v$NEW_VERSION
    ```

4. Update the `.version` in `charts/edb-postgres-distributed-for-kubernetes/Chart.yaml` to `"X.Y.Z"`

    ```bash
    sed -i -E "s/^version: \"([0-9]+.?)+\"/version: \"$NEW_VERSION\"/" charts/edb-postgres-distributed-for-kubernetes/Chart.yaml
    ```

5. Update everything else as required, if releasing due to a new
    `edb-postgres-distributed-for-kubernetes` version being released, you might
    want to:

    1. Find the latest `edb-postgres-distributed-for-kubernetes` version by running:

        ```bash
        NEW_PGD4K_VERSION=$(
          gh api "https://api.github.com/repos/EnterpriseDB/pg4k-pgd/tags" | \
          jq -r '.[0].name | ltrimstr("v")')
        echo $NEW_PGD4K_VERSION
        ```

    2. Update `.appVersion` in [Chart.yaml](./charts/edb-postgres-distributed-for-kubernetes/Chart.yaml)
        file

        ```bash
        sed -i -E "s/^appVersion: \"([0-9]+.?)+\"/appVersion: \"$NEW_PGD4K_VERSION\"/" \
          charts/edb-postgres-distributed-for-kubernetes/Chart.yaml
        ```

    3. Update [crds.yaml](./charts/edb-postgres-distributed-for-kubernetes/templates/crds/crds.yaml),
        which can be built using
        [kustomize](https://kustomize.io/) from the [PGD4K repo](https://github.com/EnterpriseDB/pg4k-pgd)
        using kustomize [remoteBuild](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/remoteBuild.md)
        running:

        ```bash
        echo '{{- if .Values.crds.create }}' > ./charts/edb-postgres-distributed-for-kubernetes/templates/crds/crds.yaml
        kustomize build https://github.com/EnterpriseDB/pg4k-pgd/config/helm/\?ref\=v$NEW_PGD4K_VERSION >> ./charts/edb-postgres-distributed-for-kubernetes/templates/crds/crds.yaml
        echo '{{- end }}' >> ./charts/edb-postgres-distributed-for-kubernetes/templates/crds/crds.yaml
        ```

    4. To update the files in the [templates](./charts/edb-postgres-distributed-for-kubernetes/templates) directory, you can diff the previous
        PG4K release yaml against the new one, to find what should be updated. E.g.,

        From the `pg4k-pgd` repo, with the desired release branch
        checked out:

        ```bash
        vimdiff ./releases/pg4k-pgd-enterprise-${OLD_PGD4K_VERSION}.yaml ./releases/pg4k-pgd-enterprise-${NEW_PGD4K_VERSION}.yaml
        ```

    5. Update [values.yaml](./charts/edb-postgres-distributed-for-kubernetes/values.yaml) if needed,
       NOTE: updating `values.yaml` just for the PGD4K version may not be necessary,
       as the value should default to the `appVersion` in `Chart.yaml`


    1. Update `PGD_IMAGE_NAME` and `PGD_PROXY_IMAGE_NAME` defaults inside [values.yaml](./charts/edb-postgres-distributed-for-kubernetes/values.yaml) according to the default versions present in the release.

    2. Update dependent `cert-manager` version in [Chart.yaml](./charts/edb-postgres-distributed-for-kubernetes/Chart.yaml) if needed

    3. Update the `.appVersion` and `.verions` in subchart [edb-postgres-for-kubernetes-lts](./charts/edb-postgres-distributed-for-kubernetes/charts/edb-postgres-for-kubernetes-lts) and follow the [PG4K Release](#releasing-the-edb-postgres-for-kubernetes-chart) to update the subchart to latest PG4K lts release if needed

    4.  Update dependent `edb-postgres-for-kubernetes-lts` version in [Chart.yaml](./charts/edb-postgres-distributed-for-kubernetes/Chart.yaml)

From here onward, you can follow the steps of the [PG4K Release](#releasing-the-edb-postgres-for-kubernetes-chart), starting from `point 6`.

**IMPORTANT**: take care to replace ` edb-postgres-for-kubernetes` with `edb-postgres-distributed-for-kubernetes` accordingly
before executing the commands.

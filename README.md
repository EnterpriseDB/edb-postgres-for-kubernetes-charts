# Cloud Native PostgreSQL Helm Chart

Helm chart to install the
[Cloud Native PostgreSQL operator](https://docs.enterprisedb.io/cloud-native-postgresql/),
designed by EnterpriseDB to manage PostgreSQL workloads on any
supported Kubernetes cluster running in private, public, or hybrid cloud
environments.

## Deployment using the latest release

```console
helm repo add cnp https://enterprisedb.github.io/cloud-native-postgresql-helm/
helm upgrade --install cnp \
  --namespace postgresql-operator-system \
  --create-namespace \
  cnp/cloud-native-postgresql
```

## Deployment using local chart

To deploy the operator from sources you can run the following command:

```console
helm upgrade --install cnp \
  --namespace postgresql-operator-system \
  --create-namespace \
  charts/cloud-native-postgresql
```

## Upgrading CRDs

Helm does not support upgrading CRDs, as explained [here](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#some-caveats-and-explanations),
therefore in order to upgrade the operator you'll need to run the following command once 
a new chart release is available:

```console
helm template cnp cnp/cloud-native-postgresql -s templates/crds/crds.yaml --include-crds | kubectl apply -f -
```

## Copyright

`cloud-native-postgresql-helm` is distributed under Apache License 2.0.

**IMPORTANT:** Both the operator and the operand images are distributed
under different license terms, in particular the Cloud Native PostgreSQL
operator is distributed under the
[EnterpriseDB Limited Use License](https://www.enterprisedb.com/limited-use-license).

Copyright (C) 2021 EnterpriseDB Corporation.

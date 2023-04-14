# EDB Postgres for Kubernetes Operator Helm Chart

Helm chart to install the
[EDB Postgres for Kubernetes operator](https://docs.enterprisedb.io/edb-postgres-for-kubernetes/),
designed by EnterpriseDB to manage PostgreSQL workloads on any
supported Kubernetes cluster running in private, public, or hybrid cloud
environments. Derived from CloudNativePG's Helm chart.

## Deployment using the latest release

```console
helm repo add edb-pg4k https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts/
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  edb-pg4k/edb-postgres-for-kubernetes
```

## Deployment using local chart

To deploy the operator from sources you can run the following command:

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  charts/edb-postgres-for-kubernetes
```

## Copyright

`edb-postgres-for-kubernetes-charts` is distributed under Apache License 2.0.

**IMPORTANT:** Both the operator and the operand images are distributed
under different license terms, in particular the EDB Postgres for Kubernetes
operator is distributed under the
[EnterpriseDB Limited Use License](https://www.enterprisedb.com/limited-use-license).

Copyright (C) 2021 EnterpriseDB Corporation.


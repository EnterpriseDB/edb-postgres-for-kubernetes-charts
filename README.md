# EDB Kubernetes Operator Helm Charts

Helm charts to install the following Operators:

- [EDB Postgres for Kubernetes operator (PG4K)](https://docs.enterprisedb.io/edb-postgres-for-kubernetes/),
   designed by EnterpriseDB to manage PostgreSQL workloads on any
   supported Kubernetes cluster running in private, public, or hybrid cloud
   environments. Derived from CloudNativePG's Helm chart.

- [EDB Postgres Distributed for Kubernetes (PG4K-PGD)](https://docs.enterprisedb.io/edb-postgres-distributed-for-kubernetes/),
   designed by EnterpriseDB to manage EDB Postgres Distributed v5 workloads
   on Kubernetes, with traffic routed by PGD Proxy.

## Usage

Before deploying the charts, add the following repository by running:

```console
helm repo add edb https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts/
```

You can then run `helm search repo edb` to see the all the available charts.

## Deployment of the EDB Postgres for Kubernetes operator (PG4K)

Both the operator and the operand images required by PG4K are
pulled from the `docker.enterprisedb.com/k8s` repository,
access to these images requires an active EDB subscription.
See: [obtaining an EDB subscription token](https://www.enterprisedb.com/docs/postgres_for_kubernetes/latest/installation_upgrade/#obtaining-an-edb-subscription-token)

For example, to deploy the operator:

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  --set image.imageCredentials.password=<THE-TOKEN> \
  edb/edb-postgres-for-kubernetes
```

This will create a deployment in the `postgresql-operator-system` namespace.
You can check it's ready:

```sh
$ kubectl get deployments -n postgresql-operator-system
NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
edb-pg4k-edb-postgres-for-kubernetes   1/1     1            1           11s
```

Once it is ready, you can verify that you can deploy the sample cluster
suggested by the helm chart.

### Single namespace installation

It is possible to limit the operator's capabilities to solely the namespace in
which it has been installed. With this restriction, the cluster-level
permissions required by the operator will be substantially reduced, and
the security profile of the installation will be enhanced.

You can install the operator in single-namespace mode by setting the
`config.clusterWide` flag to false, as in the following example:

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  --set config.clusterWide=false \
  --set image.imageCredentials.password=<THE-TOKEN> \
  edb/edb-postgres-for-kubernetes
```

**IMPORTANT**: the single-namespace installation mode can't coexist
with the cluster-wide operator. Otherwise there would be collisions when
managing the resources in the namespace watched by the single-namespace
operator.
It is up to the user to ensure there is no collision between operators.

## Deployment of the EDB Postgres Distributed for Kubernetes operator (PG4K-PGD)

Similar to the PG4K helm chart installation, both the operator and the operand images
required by PG4K-PGD are pulled from the `docker.enterprisedb.com/k8s` repository,
access to these images requires an active EDB subscription. See: [obtaining an EDB subscription token](https://www.enterprisedb.com/docs/postgres_distributed_for_kubernetes/latest/installation_upgrade/#obtaining-an-edb-subscription-token)

The PG4K-PGD chart installs both the PG4K-PGD and PG4K operators in the
same namespace. The PG4K operator installed is a stable version that is
part of the latest long-term support release of PG4K.

The PG4K-PGD chart also install the cert-manager operator as a dependency.
You can avoid this if necessary. See the sub-section
[on deploying individually](#deploying-the-PG4K-PGD-operators-individually).

For example, to deploy the operator:

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  --set image.imageCredentials.password=<THE-TOKEN> \
  edb/edb-postgres-distributed-for-kubernetes
```

Once the above runs, a new namespace `pgd-operator-system` will be
created, with several deployments,  including the two operators.

```sh
$ kubectl get deployments -n pgd-operator-system
NAME                                                   READY   UP-TO-DATE   AVAILABLE   AGE
edb-pg4k-pgd-cert-manager                              1/1     1            1           7m46s
edb-pg4k-pgd-cert-manager-cainjector                   1/1     1            1           7m46s
edb-pg4k-pgd-cert-manager-webhook                      1/1     1            1           7m46s
edb-pg4k-pgd-edb-postgres-distributed-for-kubernetes   1/1     1            1           7m46s
edb-pg4k-pgd-edb-postgres-for-kubernetes-lts           1/1     1            1           7m46s
```

When the deployments are ready, you can verify that the steps suggested by the
helm chart are working:

- set up a cert-manager issuer
- deploy an example 3-region PGD cluster

### Deploying the PG4K-PGD operators and cert-manager individually

The chart `edb-postgres-distributed-for-kubernetes` is set by default to
also install the cert-manager operator, which it depends on.
When following this route, all operators will be installed in the same
namespace. This is in contrast with other installation paths, where we
may want the two operators reside in dedicated namespaces.

Installing all dependencies in the same namespace is a design limitation of
Helm, but we can get around it by installing dependencies with separate
invocations of `helm`.

If you would like to install the cert-manager in a separate namespace, please
follow the steps below.

#### 1. Setup cert-manager

EDB Postgres Distributed for Kubernetes requires Cert Manager 1.10 or higher.

**Note:** In case a supported version of the cert-manager operator is already deployed
in your K8S setup, you can skip this section and go directly to the setup of [PG4K-PGD](#setup-pg4k-pgd).

To deploy cert-manager in its own namespace

```console
$ helm repo add jetstack https://charts.jetstack.io &&
  helm upgrade --install cert-manager jetstack/cert-manager \
  --create-namespace \
  --namespace cert-manager \
  --version "v1.16.1" \
  --set installCRDs=true \
  --wait
```

In case you choose this option, remember to also specify
`--set cert-manager.enabled=false` during the installation of the PG4K-PGD
helm chart in the next section.

#### 2. Setup PG4K-PGD

Once the above deployments are ready, you can deploy the PG4K-PGD
helm chart taking care to set `cert-manager.enabled`
to false if cert-manager is installed separately.

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  --set image.imageCredentials.password=<THE-TOKEN> \
  --set cert-manager.enabled=false \
  edb/edb-postgres-distributed-for-kubernetes
```

You should now have a separate namespace for each operator:

```sh
$ kubectl get ns
NAME                         STATUS   AGE
…
cert-manager                 Active   24m
pgd-operator-system          Active   55s
```

## Migrating existing deployments to the unified `k8s` repository

If you have existing Helm deployments using the previous separate repositories
(`k8s_enterprise`, `k8s_standard`, `k8s_enterprise_pgd`, `k8s_standard_pgd`),
you need to migrate them to the new unified `docker.enterprisedb.com/k8s` repository.

For **EDB Postgres for Kubernetes (PG4K)** releases:
```console
helm upgrade --reuse-values \
  --set image.repository=docker.enterprisedb.com/k8s/edb-postgres-for-kubernetes \
  --set image.imageCredentials.username=k8s \
  edb-pg4k \
  edb/edb-postgres-for-kubernetes
```

For **EDB Postgres Distributed for Kubernetes (PG4K-PGD)** releases:
```console
helm upgrade --reuse-values \
  --set global.repository=docker.enterprisedb.com/k8s \
  --set image.imageCredentials.username=k8s \
  edb-pg4k-pgd \
  edb/edb-postgres-distributed-for-kubernetes
```

For more details, see the [official migration guide](https://www.enterprisedb.com/docs/postgres_for_kubernetes/latest/migrating_edb_registries/).

### Customized the PGD image

By default, the Helm chart-installed operator adds default PGD and PGD proxy image
names to the configuration file. PGD groups created without `spec.imageName` and
`spec.pgdProxy.imageName` will use those defaults. You can customize the defaults
by setting them in the Helm values.

- `pgdImageName`: the default PGD image name to be used by the operator.
- `proxyImageName`: the default PGD proxy image name to be used by the operator.

This example changed the default PGD and PGD proxy image:

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  --set image.imageCredentials.password=<THE-TOKEN> \
  --set global.pgdImageName=edb-postgres-advanced-pgd:17.6-pgd590-ubi9 \
  --set global.proxyImageName=edb-pgd-proxy:5.9.0-ubi9  \
  edb/edb-postgres-distributed-for-kubernetes
```

**Note:** You can find more latest released image catalogs for operand from
[PGD Operand images](https://www.enterprisedb.com/docs/postgres_distributed_for_kubernetes/latest/supported_versions/#pgd-operand-images)


## Deployment using local chart

### Deployment PG4K using local chart

To deploy an operator from source, first clone the current repository
locally and then run the following command: (Example for EDB-PG4K)

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  charts/edb-postgres-for-kubernetes
```

### Deployment PG4K-PGD using local chart

Navigate to the charts directory of local chart or source code,
To deploy PG4K-PGD with all dependencies together

```console
helm upgrade --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  --set image.imageCredentials.password=<THE-TOKEN> \
  charts/edb-postgres-distributed-for-kubernetes
```

To deploy the PG4K LTS subchart separately in a different namespace.

```console
helm upgrade --install edb-pg4k-lts \
  --namespace postgresql-operator-system \
  --create-namespace \
  --set image.imageCredentials.create=true \
  --set image.imageCredentials.password=<THE-TOKEN> \
  charts/edb-postgres-distributed-for-kubernetes/charts/edb-postgres-for-kubernetes-lts
```

and then deploy the PG4K-PGD chart with `edb-postgres-for-kubernetes-lts.enabled=false`
set.

```console
helm upgrade --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  --set image.imageCredentials.password=<THE-TOKEN> \
  --set edb-postgres-for-kubernetes-lts.enabled=false \
  charts/edb-postgres-distributed-for-kubernetes
```

If you update the version of the dependency charts and want to install from
source, remember to run `helm dependency update` and `helm dependency build` in
the chart directory before installing from the source.

## Copyright

`edb-postgres-for-kubernetes-charts` is distributed under Apache License 2.0.

**IMPORTANT:** Both the operators and the operand images are distributed
under different license terms, in particular the `EDB Postgres for Kubernetes operator`
and the `EDB Postgres Distributed for Kubernetes operator`
are distributed under the
[EnterpriseDB End User License Agreement](https://www.enterprisedb.com/legal/EDB-Eula).

Copyright (C) 2021 EnterpriseDB Corporation.

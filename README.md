# EDB Kubernetes Operator Helm Charts

Helm charts to install the following Operators:

1. [EDB Postgres for Kubernetes operator (PG4K)](https://docs.enterprisedb.io/edb-postgres-for-kubernetes/),
designed by EnterpriseDB to manage PostgreSQL workloads on any
supported Kubernetes cluster running in private, public, or hybrid cloud
environments. Derived from CloudNativePG's Helm chart.

2. [EDB Postgres Distributed for Kubernetes (PG4K-PGD)](https://docs.enterprisedb.io/edb-postgres-distributed-for-kubernetes/),
designed by EnterpriseDB to manage EDB Postgres Distributed v5 workloads
on Kubernetes, with traffic routed by PGD Proxy.

## Usage

Before deploying the charts, add the following repository by running:

```console
helm repo add edb https://enterprisedb.github.io/edb-postgres-for-kubernetes-charts/
```

You can then run `helm search repo edb` to see the all the available charts.

## Deployment of the EDB Postgres for Kubernetes operator (PG4K)

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  edb/edb-postgres-for-kubernetes
```

This will create a deployment in the `postgresql-operator-system` namespace.
You can check it's ready:

``` sh
$ kubectl get deployments -n postgresql-operator-system
NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
edb-pg4k-edb-postgres-for-kubernetes   1/1     1            1           11s
```

Once it is ready, you can verify that you can deploy the sample cluster
suggested by the helm chart.

### Deploying EDB Postgres for Kubernetes (PG4K) operator from EDB's private registry

By default, PG4K will be deployed using [images publicly hosted on Quay.io](https://quay.io/repository/enterprisedb/cloud-native-postgresql),
without a `pullSecret` but requiring a [license key](https://www.enterprisedb.com/docs/postgres_for_kubernetes/latest/license_keys/).

Additionally, both the operator and the operand images required by PG4K may be
pulled from the `k8s_enterprise` or `k8s_standard` repositories at
`docker.enterprisedb.com`, available with an EDB subscription plan.

To do that, you need to configure the chart to pull images from a private
registry (this works similarly in case you want to host the operator images in
your own private registry).

For example, to deploy via the `k8s_enterprise` repository:

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  --set image.repository=docker.enterprisedb.com/k8s_enterprise/edb-postgres-for-kubernetes \
  --set image.imageCredentials.username=k8s_enterprise \
  --set image.imageCredentials.password=<THE-TOKEN> \
  --set image.imageCredentials.create=true \
  --set imagePullSecrets[0].name=postgresql-operator-pull-secret \
  --set config.data.PULL_SECRET_NAME=postgresql-operator-pull-secret \
  edb/edb-postgres-for-kubernetes
```

> **Note:** If instead you want to deploy using the `k8s_standard` repository,
> you can do that by adjusting the following settings in the above example:
>
> - Set `image.repository` to `docker.enterprisedb.com/k8s_standard/edb-postgres-for-kubernetes`
> - Set `image.imageCredentials.username` to `k8s_standard`

## Deployment of the EDB Postgres Distributed for Kubernetes operator (PG4K-PGD)

**Note:** the `edb-postgres-distributed-for-kubernetes` chart will by default
also install PG4K and cert-manager operators, which are dependencies.
You can avoid this if necessary. See the sub-section
[on deploying individually](#deploying-the-operators-individually).

**Note:** this helm chart sets sensible defaults for the location of the operand
images. If you need to use other repositories, please see the section on
[controlling the image repositories](#controlling-the-image-repositories).

**Note:** You will need credentials to retrieve the various
operator and operand images. Make sure to replace $USERNAME and $PASSWORD with
your own credentials in the command below:

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  edb/edb-postgres-distributed-for-kubernetes \
  --set image.imageCredentials.username=${USERNAME} \
  --set image.imageCredentials.password=${PASSWORD}
```

Once the above runs, a new namespace `pgd-operator-system` will be
created, with several deployments,  including the two operators.

``` sh
$ kubectl get deployments -n pgd-operator-system
NAME                                                   READY   UP-TO-DATE   AVAILABLE   AGE
edb-pg4k-pgd-cert-manager                              1/1     1            1           7m46s
edb-pg4k-pgd-cert-manager-cainjector                   1/1     1            1           7m46s
edb-pg4k-pgd-cert-manager-webhook                      1/1     1            1           7m46s
edb-pg4k-pgd-edb-postgres-distributed-for-kubernetes   1/1     1            1           7m46s
edb-pg4k-pgd-edb-postgres-for-kubernetes               1/1     1            1           7m46s
```

When the deployments are ready, you can verify that the steps suggested by the
helm chart are working:

- set up a cert-manager issuer
- deploy an example 3-region PGD cluster

### Deploying the operators individually

The chart `edb-postgres-distributed-for-kubernetes` is set by default to
also install PG4K and cert-manager operators, which it depends on.
When following this route, all operators will be installed in the same
namespace. This is in contrast with other installation paths, where the
operators reside in dedicated namespaces.

Installing all dependencies in the same namespace is a design limitation of
Helm, but we can get around it by installing dependencies with separate
invocations of `helm`.

If you would like to install the operators in separate namespaces, please follow
the below steps.

First, deploy the [PG4K helm chart](#deployment-of-the-edb-postgres-for-kubernetes-operator-pg4k).

### Controlling the image repositories

The various operator and operand images necessary for PGD may be pulled
from a variety of repositories.
By default, this helm chart is set up to use the `k8s_enterprise_pgd` repository, available
with the *Enterprise* subscription plan.
In case you have a different subscription plan and need to use a different repository
than what is configured by default, you may do so by adding the appropriate overrides
with the `--set` option.

Assuming, as in the section above, that you have your necessary credentials,
note the additional `--set` options for the `image.repository`, `PGD_IMAGE_NAME` and
`PGD_PROXY_IMAGE_NAME` keys to customize the PGD operator deployment.

For example, to deploy using the `k8s_standard_pgd` repository:

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  edb/edb-postgres-distributed-for-kubernetes \
  --set image.imageCredentials.username=${USERNAME} \
  --set image.imageCredentials.password=${PASSWORD} \
  --set image.repository=docker.enterprisedb.com/k8s_standard_pgd/pg4k-pgd \
  --set edb-postgres-for-kubernetes.image.repository=docker.enterprisedb.com/k8s_standard_pgd/edb-postgres-for-kubernetes \
  --set config.data.PGD_IMAGE_NAME=docker.enterprisedb.com/k8s_standard_pgd/postgresql-pgd:15.2-5.0.0-1 \
  --set config.data.PGD_PROXY_IMAGE_NAME=docker.enterprisedb.com/k8s_standard_pgd/edb-pgd-proxy:5.0.1-131
```

#### Setup cert-manager

EDB Postgres Distributed for Kubernetes also requires Cert Manager 1.10 or higher.

**Note:** In case a supported version of the cert-manager operator is already deployed
in your K8S setup, you can skip this section and go directly to the setup of [PG4K-PGD](#setup-pg4k-pgd).

You can decide to either:

1. Also deploy cert-manager in its own namespace

``` sh
$ helm repo add jetstack https://charts.jetstack.io
$ helm upgrade --install cert-manager jetstack/cert-manager \
  --create-namespace \
  --namespace cert-manager \
  --version "v1.11.1" \
  --set installCRDs=true \
  --wait
```

In case you choose this option, remember to also specify `--set cert-manager.enabled=false`
during the installation of the PG4K-PGD helm chart in the next section.

2. Deploy cert-manager as a PG4K-PGD dependency

This is the default option. Unless `--set cert-manager.enabled=false` is set
during the installation of the PG4K-PGD helm chart, cert-manager will be installed
as part of the PG4K-PGD namespace.

#### Setup PG4K-PGD

Once the above deployments are ready, you can run the PG4K-PGD helm chart, taking care
to set `edb-postgres-for-kubernetes.enabled` to false.

**Note**: In the following example, cert-manager will be installed alongside PG4K-PGD
in the same namespace. If you don't want that, consider setting also `cert-manager.enabled`
to false. See the [cert-manager section](#setup-cert-manager).

``` sh
$ helm upgrade \
  --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace charts/edb-postgres-distributed-for-kubernetes \
  --set edb-postgres-for-kubernetes.enabled=false \
  --wait
```

**Note:** in the above command, the flags setting the credentials were elided
to put the focus on the `enabled=false` condition. The flags may still be
necessary, unless the credentials are provided in the `values.yaml` file.

You can see the two separate namespaces, the same that would be created if
installing manually without Helm charts.

``` sh
$ kubectl get ns
NAME                         STATUS   AGE
default                      Active   6m28s
…
pgd-operator-system          Active   55s
postgresql-operator-system   Active   5m33s
```

## Deployment using local chart

To deploy an operator from source, first clone the current repository
locally and then run the following command: (Example for EDB-PG4K)

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  charts/edb-postgres-for-kubernetes
```

If you update the version of the dependency charts and want to install from
source, remember to run `helm dependency update` and `helm dependency build` in
the chart directory before installing from the source.

## Copyright

`edb-postgres-for-kubernetes-charts` is distributed under Apache License 2.0.

**IMPORTANT:** Both the operators and the operand images are distributed
under different license terms, in particular the `EDB Postgres for Kubernetes operator`
and the `EDB Postgres Distributed for Kubernetes operator` are distributed under the
[EnterpriseDB Limited Use License](https://www.enterprisedb.com/limited-use-license).

Copyright (C) 2021 EnterpriseDB Corporation.

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

Both the operator and the operand images required by PG4K may be
pulled from the `k8s_enterprise` or `k8s_standard` repositories at
`docker.enterprisedb.com`, available with an EDB subscription plan.
See: [obtaining an EDB subscription token](https://www.enterprisedb.com/docs/postgres_for_kubernetes/latest/installation_upgrade/#obtaining-an-edb-subscription-token)

By default, the chart will try to pull the operator image from `k8s_enterprise`.
To do that, you need to configure the chart to pull images from a private
registry (this works similarly in case you want to host the operator images in
your own private registry).

For example, to deploy via the `k8s_enterprise` repository:

```console
helm upgrade --install edb-pg4k \
  --namespace postgresql-operator-system \
  --create-namespace \
  --set image.imageCredentials.username=k8s_enterprise \
  --set image.imageCredentials.password=<THE-TOKEN> \
  edb/edb-postgres-for-kubernetes
```

> **Note:** If instead you want to deploy using the `k8s_standard` repository,
> you can do that by adjusting the following settings in the above example:
>
> - Set `image.repository` to `docker.enterprisedb.com/k8s_standard/edb-postgres-for-kubernetes`
> - Set `image.imageCredentials.username` to `k8s_standard`

This will create a deployment in the `postgresql-operator-system` namespace.
You can check it's ready:

``` sh
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
  --set image.imageCredentials.username=k8s_enterprise \
  --set image.imageCredentials.password=<THE-TOKEN> \
  edb/edb-postgres-for-kubernetes
```

**IMPORTANT**: the single-namespace installation mode can't coexist
with the cluster-wide operator. Otherwise there would be collisions when
managing the resources in the namespace watched by the single-namespace
operator.
It is up to the user to ensure there is no collision between operators.

## Deployment of the EDB Postgres Distributed for Kubernetes operator (PG4K-PGD)

Like PG4K install, both the operator and the operand images required by PG4K-PGD
may be pulled from the `k8s_enterprise` or `k8s_standard` repositories at
`docker.enterprisedb.com`, please obtaining an EDB subscription token before setup.

The `edb-postgres-distributed-for-kubernetes` chart will by default install PG4K
operator defined by sub-chart in the same namespace, the PG4K operator installed
in the sub-chart is PG4K LTS release operator, which is upgraded along with the
parent chart version release.

The `edb-postgres-distributed-for-kubernetes` chart also install the cert-manager
operators as dependency. You can avoid this if necessary. See the sub-section
[on deploying individually](#deploying-the-PG4K-PGD-operators-individually).

**Note:** this helm chart uses a default registry to retrieve the operator
images from: `docker.enterprisedb.com/k8s_enterprise_pgd`.
If you want to use another registry, you will need set it explicitly.
For more information please see the section
on [controlling the image repositories](#controlling-the-image-repositories).

**Note:** You will need credentials to retrieve the various
operator and operand images. Make sure to replace USERNAME and PASSWORD with
your own credentials in the command below, which uses the `k8s_enterprise_pgd`
image registry by default:

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace  edb/edb-postgres-distributed-for-kubernetes \
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
edb-pg4k-pgd-edb-postgres-for-kubernetes-lts           1/1     1            1           7m46s
```

When the deployments are ready, you can verify that the steps suggested by the
helm chart are working:

- set up a cert-manager issuer
- deploy an example 3-region PGD cluster

### Deploying the PG4K-PGD operators and cert-manager individually

The chart `edb-postgres-distributed-for-kubernetes` is set by default to
also install PG4K and cert-manager operators, which it depends on.
When following this route, all operators will be installed in the same
namespace. This is in contrast with other installation paths, where the
operators reside in dedicated namespaces.

Installing all dependencies in the same namespace is a design limitation of
Helm, but we can get around it by installing dependencies with separate
invocations of `helm`.

If you would like to install the cert-manager in separate namespaces, please
follow the below steps.

#### 1. Setup cert-manager

EDB Postgres Distributed for Kubernetes requires Cert Manager 1.10 or higher.

**Note:** In case a supported version of the cert-manager operator is already deployed
in your K8S setup, you can skip this section and go directly to the setup of [PG4K-PGD](#setup-pg4k-pgd).

You can decide to deploy the cert-manager in its own namespaces, or deploy cert-manager
as a dependency of PG4K-PGD, which will be installed in same namespace with
PG4K-PGD operator.

To deploy cert-manager in its own namespace

``` sh
$ helm repo add jetstack https://charts.jetstack.io
$ helm upgrade --install cert-manager jetstack/cert-manager \
  --create-namespace \
  --namespace cert-manager \
  --version "v1.16.1" \
  --set installCRDs=true \
  --wait
```

In case you choose this option, remember to also specify
`--set cert-manager.enabled=false` during the installation of the PG4K-PGD
helm chart in the next section.

#### 2. Setup PG4K

By default, a PG4K operator with LTS release is installed alongside with PG4K-PGD
deploy. You can follow [PG4K helm chart](#deployment-of-the-edb-postgres-for-kubernetes-operator-pg4k)
to deploy the PG4K operator in its own namespace. But it is highly recommended to use
the PG4K operator installed as dependency of PG4K-PGD chart, which contains the well tested PG4K
operator version.

In case you choose to use existing PG4K operator, remember to also specify
`--set edb-postgres-for-kubernetes-lts.enabled=false` during the installation of the PG4K-PGD
helm chart in the next section.

#### 3. Setup PG4K-PGD

Once the above deployments are ready, you can deploy the PG4K-PGD helm chart. taking care
to set `edb-postgres-for-kubernetes-lts.enabled` to false if you PG4K already deployed,
and set `cert-manager.enabled` to false if cert-manager is installed separately.

**Note:** in the following example, the flags setting the credentials were elided
to put the focus on the `enabled=false` condition. The flags may still be
necessary, unless the credentials are provided in the `values.yaml` file.

``` sh
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  edb/edb-postgres-distributed-for-kubernetes \
  --set cert-manager.enabled=false
  --set edb-postgres-for-kubernetes-lts.enabled=false
```

You can see the three separate namespaces, the same that would be created if
installing manually without Helm charts.

``` sh
$ kubectl get ns
NAME                         STATUS   AGE
…
cert-manager                 Active   24m
pgd-operator-system          Active   55s
postgresql-operator-system   Active   5m33s
```

### Controlling the image repositories

The various operator and operand images necessary for PGD may be pulled
from a variety of repositories. This helm chart uses `k8s_enterprise_pgd`
as the default repository. If you want to use another, you will need to
fill in the image registry and the credentials, according to your
subscription plan. This needs to be done in several places in the command-line
invocation.

The following example uses the `k8s_standard_pgd` registry in
`docker.enterprisedb.com`.
Note the multiple `--set` options, for the `image.repository`,
`PGD_IMAGE_NAME` and `PGD_PROXY_IMAGE_NAME` in addition to the
`edb-postgres-for-kubernetes-lts.image.repository` where the PGD operator
is pulled from. There are 4 in total
- `image.repository` where the PG4K-PGD operator image is pulled from.
- `edb-postgres-for-kubernetes-lts.image.repository` where the PG4K operator image is pulled from.
- `PGD_IMAGE_NAME` and `PGD_PROXY_IMAGE_NAME` where the PGD and PGD Proxy image are pulled from.

Assuming that you have your necessary credentials, please fill in the USERNAME
and PASSWORD below.

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  edb/edb-postgres-distributed-for-kubernetes \
  --set image.imageCredentials.username=${USERNAME} \
  --set image.imageCredentials.password=${PASSWORD} \
  --set image.repository=docker.enterprisedb.com/k8s_standard_pgd/pg4k-pgd \
  --set edb-postgres-for-kubernetes-lts.image.repository=docker.enterprisedb.com/k8s_standard_pgd/edb-postgres-for-kubernetes \
  --set config.data.PGD_IMAGE_NAME=docker.enterprisedb.com/k8s_standard_pgd/postgresql-pgd:15.6-5.5.1-1 \
  --set config.data.PGD_PROXY_IMAGE_NAME=docker.enterprisedb.com/k8s_standard_pgd/edb-pgd-proxy:5.5.0
```

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
  charts/edb-postgres-distributed-for-kubernetes
```

To deploy the PG4K LTS subchart separately in a different namespace.

```console
helm upgrade --install edb-pg4k-lts \
  --namespace postgresql-operator-system \
  --create-namespace \
  charts/edb-postgres-distributed-for-kubernetes/charts/edb-postgres-for-kubernetes-lts
```

and then deploy the PG4K-PGD chart.

```
helm upgrade --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  charts/edb-postgres-distributed-for-kubernetes \
  --set edb-postgres-for-kubernetes-lts.enabled=false
```

**Note:** The image locations and the credentials are elided. Please refer to
the sections above for directions.

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

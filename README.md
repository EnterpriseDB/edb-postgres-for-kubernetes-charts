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

## Credentials

The images for the operators and operands are held in different repositories.
The most convenient way to install the operators and operands would be to have
a user token with access to all the repositories.
But if that is not available, individual *entitlement keys* will need to be
used for each repository.

## Deployment of the EDB Postgres Distributed for Kubernetes operator (PG4K-PGD)

**Note:** the `edb-postgres-distributed-for-kubernetes` chart will by default
also install the PG4K operator, which is a dependency.
You can avoid this if necessary. See the sub-section
[on deploying individually](#deploying-the-operators-individually).

**Note:** You will need [credentials](#credentials) to retrieve the various
operator and operand images. Make sure to replace $USERNAME and $PASSWORD with
 your own credentials in the command below:

```console
helm upgrade --dependency-update \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace \
  edb/edb-postgres-distributed-for-kubernetes \
  --set image.imageCredentials.username=${USERNAME} \
  --set image.imageCredentials.password=${PASSWORD} \
  --set edb-postgres-for-kubernetes.image.imageCredentials.username=${USERNAME} \ 
  --set edb-postgres-for-kubernetes.image.imageCredentials.password="${PASSWORD}
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
also install the PG4K operator, which it depends on.
When following this route, both operators will be installed in the same
namespace. This is in contrast with other installation paths, where the
operators reside in dedicated namespaces.

Installing all dependencies in the same namespace is a design limitation of
Helm, but we can get around it by installing dependencies with separate
invocations of `helm`.

If you would like to install the operators in separate namespaces, first deploy
the
[PG4K helm chart](#deployment-of-the-edb-postgres-for-kubernetes-operator-pg4k).

Once the deployment is ready, you can run the PG4K-PGD helm chart, taking care
to set `edb-postgres-for-kubernetes.enabled` to false:

``` sh
$ helm dependency update charts/edb-postgres-distributed-for-kubernetes
$ helm upgrade \
  --install edb-pg4k-pgd \
  --namespace pgd-operator-system \
  --create-namespace charts/edb-postgres-distributed-for-kubernetes\
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

## Copyright

`edb-postgres-for-kubernetes-charts` is distributed under Apache License 2.0.

**IMPORTANT:** Both the operators and the operand images are distributed
under different license terms, in particular the `EDB Postgres for Kubernetes operator`
and the `EDB Postgres Distributed for Kubernetes operator` are distributed under the
[EnterpriseDB Limited Use License](https://www.enterprisedb.com/limited-use-license).

Copyright (C) 2021 EnterpriseDB Corporation.


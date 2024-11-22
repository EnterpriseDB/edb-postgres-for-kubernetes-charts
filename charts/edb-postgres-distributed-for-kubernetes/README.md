# edb-postgres-distributed-for-kubernetes

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.1](https://img.shields.io/badge/AppVersion-1.0.1-informational?style=flat-square)

EDB Postgres Distributed for Kubernetes Helm Chart

**Homepage:** <https://www.enterprisedb.com/products/postgresql-on-kubernetes-ha-clusters-k8s-containers-scalable>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| gbartolini | <gabriele.bartolini@enterprisedb.com> |  |
| jsilvela | <jaime.silvela@enterprisedb.com> |  |
| litaocdl | <tao.li@enterprisedb.com> |  |
| NiccoloFei | <niccolo.fei@enterprisedb.com> |  |

## Source Code

* <https://github.com/EnterpriseDB/edb-postgres-for-kubernetes-charts>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.jetstack.io | cert-manager | 1.16.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalArgs | list | `[]` | Additional arguments to be added to the operator's args list |
| affinity | object | `{}` | Affinity for the operator to be installed |
| cert-manager.enabled | bool | `true` |  |
| cert-manager.installCRDs | bool | `true` |  |
| commonAnnotations | object | `{}` | Annotations to be added to all other resources |
| config.create | bool | `true` | Specifies whether the secret should be created |
| config.data.PGD_IMAGE_NAME | string | `"docker.enterprisedb.com/k8s_enterprise_pgd/postgresql-pgd:16.4-5.5.1-1"` | Specifies the location of the pgd image to be used for the operator docker.enterprisedb.com/k8s_standard_pgd/postgresql-pgd:16.4-5.5.1-1 |
| config.data.PGD_PROXY_IMAGE_NAME | string | `"docker.enterprisedb.com/k8s_enterprise_pgd/edb-pgd-proxy:5.5.0"` | Specifies the location of the pgd-proxy image to be used for the operator  docker.enterprisedb.com/k8s_standard_pgd/edb-pgd-proxy:5.5.0 |
| config.data | object | `{}` | The content of the configmap/secret, see https://www.enterprisedb.com/docs/postgres_for_kubernetes/latest/operator_conf/#available-options for all the available options. |
| config.data.PULL_SECRET_NAME | string | `"edb-pull-secret"` |
| config.name | string | `"pgd-operator-controller-manager-config"` |  |
| config.secret | bool | `false` | Specifies whether it should be stored in a secret, instead of a configmap |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":10001,"runAsUser":10001}` | Container Security Context |
| crds.create | bool | `true` |  ||
| edb-postgres-for-kubernetes-lts.enable | bool | `true` | |
| edb-postgres-for-kubernetes-lts.image.repository | string | `"docker.enterprisedb.com/k8s_enterprise_pgd/edb-postgres-for-kubernetes"` | |
| edb-postgres-for-kubernetes-lts.image.imagePullSecrets[0].name | string| `"edb-pull-secret"` | |
| edb-postgres-for-kubernetes-lts.config.data.PULL_SECRET_NAME| string| `"edb-pull-secret"` | |
| imagePullSecrets[0].name | string | `"edb-pull-secret"` |  |
| fullnameOverride | string | `""` |  |
| image.imageCredentials.create | bool | `true` | Specifies if an imagePullSecret should be created |
| image.imageCredentials.name | string | `"edb-pull-secret"` |  |
| image.imageCredentials.password | string | `""` |  |
| image.imageCredentials.registry | string | `"docker.enterprisedb.com"` |  |
| image.imageCredentials.username | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"docker.enterprisedb.com/k8s_enterprise_pgd/pg4k-pgd"` |  |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| managerConfig.data.health.healthProbeBindAddress | string | `":9443"` |  |
| managerConfig.data.leaderElection.enabled | bool | `true` |  |
| managerConfig.data.leaderElection.resourceName | string | `"e72f3162.k8s.enterprisedb.io"` |  |
| managerConfig.data.metrics.bindAddress | string | `"127.0.0.1:8080"` |  |
| managerConfig.name | string | `"pgd-operator-manager-config"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | Nodeselector for the operator to be installed |
| podAnnotations | object | `{}` | Annotations to be added to the pod |
| podSecurityContext | object | `{"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security Context for the whole pod |
| priorityClassName | string | `""` | Priority indicates the importance of a Pod relative to other Pods. |
| rbac.create | bool | `true` | Specifies whether ClusterRole, ClusterRoleBinding, RoleBinding and Role should be created |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service.name | string | `"pgd-operator-webhook-service"` | DO NOT CHANGE THE SERVICE NAME as it is currently used to generate the certificate and can not be configured |
| service.port | int | `443` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.create | bool | `true` | Specifies whether the service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Tolerations for the operator to be installed |
| webhook.livenessProbe.initialDelaySeconds | int | `15` |  |
| webhook.livenessProbe.periodSeconds | int | `20` |  |
| webhook.mutating.create | bool | `true` |  |
| webhook.mutating.failurePolicy | string | `"Fail"` |  |
| webhook.port | int | `9443` |  |
| webhook.readinessProbe.initialDelaySeconds | int | `15` |  |
| webhook.readinessProbe.periodSeconds | int | `20` |  |
| webhook.validating.create | bool | `true` |  |
| webhook.validating.failurePolicy | string | `"Fail"` |  |

## Values for PG4K operator settings

We can use prefix `edb-postgres-for-kubernetes-lts.` to specific the configuration for PG4K values if you want to overwrite the default one.
For a list of PG4K operator configuration values, please see [PG4K Values doc](https://github.com/EnterpriseDB/edb-postgres-for-kubernetes-charts/blob/main/charts/edb-postgres-for-kubernetes/README.md#values)

edb-postgres-for-kubernetes-lts:
  enabled: true
  image:
    repository: docker.enterprisedb.com/k8s_enterprise_pgd/edb-postgres-for-kubernetes
  imagePullSecrets:
    - name: edb-pull-secret
  config:
    data:
      PULL_SECRET_NAME: edb-pull-secret

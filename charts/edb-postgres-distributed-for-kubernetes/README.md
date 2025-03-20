# edb-postgres-distributed-for-kubernetes

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.1](https://img.shields.io/badge/AppVersion-1.1.1-informational?style=flat-square)

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
|  | edb-postgres-for-kubernetes-lts | 0.25.1 |
| https://charts.jetstack.io | cert-manager | 1.16.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalArgs | list | `[]` | Additional arguments to be added to the operator's args list |
| additionalEnv | list | `[]` | Array containing extra environment variables which can be templated. For example:  - name: RELEASE_NAME    value: "{{ .Release.Name }}"  - name: MY_VAR    value: "mySpecialKey" |
| affinity | object | `{}` | Affinity for the operator to be installed |
| cert-manager.enabled | bool | `true` |  |
| cert-manager.installCRDs | bool | `true` |  |
| commonAnnotations | object | `{}` | Annotations to be added to all other resources |
| config.create | bool | `true` | Specifies whether to enable the operator's configuration. Enabling this will create a ConfigMap or Secret (based on the 'secret' field) |
| config.data.PGD_IMAGE_NAME | string | `""` | Specifies the location of the pgd image (include path) to be used for the operator this will overwrite the global repository/pgdImageName |
| config.data.PGD_PROXY_IMAGE_NAME | string | `""` | Specifies the location of the pgd-proxy image (include path) to be used for the operator  this will overwrite the global repository/proxyImageName |
| config.data.PULL_SECRET_NAME | string | `"edb-pull-secret"` |  |
| config.name | string | `"pgd-operator-controller-manager-config"` |  |
| config.secret | bool | `false` | Specifies whether it should be stored in a secret, instead of a configmap |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":10001,"runAsUser":10001}` | Container Security Context |
| crds.create | bool | `true` |  |
| dnsPolicy | string | `""` |  |
| edb-postgres-for-kubernetes-lts.crds.create | bool | `true` |  |
| edb-postgres-for-kubernetes-lts.enabled | bool | `true` |  |
| edb-postgres-for-kubernetes-lts.image.repository | string | `""` | Specifies the repository of the pg4k operator image, this will overwrite the global repository |
| fullnameOverride | string | `""` |  |
| global | object | `{"pgdImageName":"postgresql-pgd:17.4-5.7.0-1","proxyImageName":"edb-pgd-proxy:5.7.0-1","repository":"docker.enterprisedb.com/k8s_enterprise_pgd"}` | Global values |
| global.pgdImageName | string | `"postgresql-pgd:17.4-5.7.0-1"` | Specifies the pgd image name to be used for the operator, the image will be downloaded from global repository |
| global.proxyImageName | string | `"edb-pgd-proxy:5.7.0-1"` | Specifies the pgd-proxy image name to be used for the operator, the image will be downloaded from global repository |
| global.repository | string | `"docker.enterprisedb.com/k8s_enterprise_pgd"` | Specifies the repository where the operator and operand image to be downloaded from repository: docker.enterprisedb.com/k8s_standard_pgd |
| hostNetwork | bool | `false` |  |
| image | object | `{"imageCredentials":{"create":true,"name":"edb-pull-secret","password":"","registry":"docker.enterprisedb.com","username":""},"imageName":"pg4k-pgd","imagePullPolicy":"IfNotPresent","imageTag":"","repository":""}` | operator image configuration |
| image.imageCredentials.create | bool | `true` | Specifies if an imagePullSecret should be created |
| image.imageName | string | `"pg4k-pgd"` | Specifies the name of the operator image to be pulled from repository |
| image.imageTag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| image.repository | string | `""` | Specifies the repository of the pgd operator image, this will overwrite the global repository |
| imagePullSecrets[0].name | string | `"edb-pull-secret"` |  |
| managerConfig.data.health.healthProbeBindAddress | string | `":9443"` |  |
| managerConfig.data.leaderElection.enabled | bool | `true` |  |
| managerConfig.data.leaderElection.resourceName | string | `"e72f3162.k8s.enterprisedb.io"` |  |
| managerConfig.data.metrics.bindAddress | string | `"127.0.0.1:8080"` |  |
| managerConfig.name | string | `"pgd-operator-manager-config"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | Nodeselector for the operator to be installed |
| podAnnotations | object | `{}` | Annotations to be added to the pod |
| podLabels | object | `{}` | Labels to be added to the pod |
| podSecurityContext | object | `{"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security Context for the whole pod |
| priorityClassName | string | `""` | Priority indicates the importance of a Pod relative to other Pods. |
| rbac.aggregateClusterRoles | bool | `false` | Aggregate ClusterRoles to Kubernetes default user-facing roles. Ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles |
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
| webhook.startupProbe.failureThreshold | int | `6` |  |
| webhook.startupProbe.periodSeconds | int | `5` |  |
| webhook.validating.create | bool | `true` |  |
| webhook.validating.failurePolicy | string | `"Fail"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

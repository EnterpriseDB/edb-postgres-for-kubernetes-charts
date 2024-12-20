# edb-postgres-distributed-for-kubernetes

![Version: 1.0.2](https://img.shields.io/badge/Version-1.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.1](https://img.shields.io/badge/AppVersion-1.0.1-informational?style=flat-square)

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
|  | edb-postgres-for-kubernetes-lts | 0.22.1 |
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
| config.create | bool | `true` | Specifies whether the secret should be created |
| config.data.PGD_IMAGE_NAME | string | `""` | Specifies the location of the pgd image (include path) to be used for the operator, this will overwrite the global repository/pgdImageName |
| config.data.PGD_PROXY_IMAGE_NAME | string | `""` | Specifies the location of the pgd image (include path) to be used for the operator, this will overwrite the global repository/pgdImageName|
| config.data.PULL_SECRET_NAME | string | `"edb-pull-secret"` |  |
| config.name | string | `"pgd-operator-controller-manager-config"` |  |
| config.secret | bool | `false` | Specifies whether it should be stored in a secret, instead of a configmap |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":10001,"runAsUser":10001}` | Container Security Context |
| crds.create | bool | `true` |  |
| dnsPolicy | string | `""` |  |
| edb-postgres-for-kubernetes-lts.crds.create | bool | `true` |  |
| edb-postgres-for-kubernetes-lts.enabled | bool | `true` |  |
| edb-postgres-for-kubernetes-lts.image.repository | string | `""` |  |
| fullnameOverride | string | `""` |  |
| global | object | `{"repository":"docker.enterprisedb.com/k8s_enterprise_pgd"}` | Global values |
| global.pgdImageName | string | `"postgresql-pgd:16.4-5.5.1-1"` | Specifies the name of pgd image to be used for the operator, this image will be downloaded from
| global.proxyImageName | string | `"edb-pgd-proxy:5.5.0"` | Specifies the name of pgd-proxy image to be used for the operator, this image will be downloaded from
| global.repository | string | `"docker.enterprisedb.com/k8s_enterprise_pgd"` | Specifies the repository where the operator image to be downloaded from. Another repository is: docker.enterprisedb.com/k8s_standard_pgd |
| hostNetwork | bool | `false` |  |
| image.imageCredentials.create | bool | `true` | Specifies if an imagePullSecret should be created |
| image.imageCredentials.name | string | `"edb-pull-secret"` |  |
| image.imageCredentials.password | string | `""` |  |
| image.imageCredentials.registry | string | `"docker.enterprisedb.com"` |  |
| image.imageCredentials.username | string | `""` |  |
| image.imageName | string | `"pg4k-pgd"` | Specifies the name of the operator image to be pulled from repository |
| image.imagePullPolicy | string | `"IfNotPresent"` |  |
| image.imageTag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| image.repository | string | `""` |  |
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
| webhook.validating.create | bool | `true` |  |
| webhook.validating.failurePolicy | string | `"Fail"` |  |

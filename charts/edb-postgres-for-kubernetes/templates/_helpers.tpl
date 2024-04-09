{{/*
Expand the name of the chart.
*/}}
{{- define "edb-postgres-for-kubernetes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "edb-postgres-for-kubernetes.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "edb-postgres-for-kubernetes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "edb-postgres-for-kubernetes.labels" -}}
helm.sh/chart: {{ include "edb-postgres-for-kubernetes.chart" . }}
{{ include "edb-postgres-for-kubernetes.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "edb-postgres-for-kubernetes.selectorLabels" -}}
app.kubernetes.io/name: cloud-native-postgresql
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "edb-postgres-for-kubernetes.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "edb-postgres-for-kubernetes.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the imagePullSecret
*/}}
{{- define "imagePullSecret" }}
{{- if .Values.image.imageCredentials.create }}
{{- with .Values.image.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Define the common set of rules that can be applied either with
namespace scope or clusterwide
*/}}
{{- define "edb-postgres-for-kubernetes.commonRules" }}
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - ""
  resources:
  - configmaps/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
- apiGroups:
  - ""
  resources:
  - persistentvolumeclaims
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - watch
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - watch
- apiGroups:
  - ""
  resources:
  - pods/exec
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - watch
- apiGroups:
  - ""
  resources:
  - pods/status
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - ""
  resources:
  - secrets/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  verbs:
  - create
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - batch
  resources:
  - jobs
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - watch
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - create
  - get
  - update
- apiGroups:
  - monitoring.coreos.com
  resources:
  - podmonitors
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - watch
- apiGroups:
  - policy
  resources:
  - poddisruptionbudgets
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - backups
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - backups/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - clusters
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - clusters/finalizers
  verbs:
  - update
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - clusters/status
  verbs:
  - get
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - poolers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - poolers/finalizers
  verbs:
  - update
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - poolers/status
  verbs:
  - get
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - scheduledbackups
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - postgresql.k8s.enterprisedb.io
  resources:
  - scheduledbackups/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - rbac.authorization.k8s.io
  resources:
  - rolebindings
  verbs:
  - create
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - rbac.authorization.k8s.io
  resources:
  - roles
  verbs:
  - create
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - snapshot.storage.k8s.io
  resources:
  - volumesnapshots
  verbs:
  - create
  - get
  - list
  - patch
  - watch
{{- end }}

{{/*
Define the set of rules that must be applied clusterwide
*/}}
{{- define "edb-postgres-for-kubernetes.clusterwideRules" }}
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - mutatingwebhookconfigurations
  verbs:
  - get
  - list
  - patch
  - update
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - validatingwebhookconfigurations
  verbs:
  - get
  - list
  - patch
  - update
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - get
  - list
  - update
{{- end }}

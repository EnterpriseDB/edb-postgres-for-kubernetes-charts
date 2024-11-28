{{/*
Expand the name of the chart.
*/}}
{{- define "edb-postgres-distributed-for-kubernetes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "edb-postgres-distributed-for-kubernetes.fullname" -}}
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
{{- define "edb-postgres-distributed-for-kubernetes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the pg4k-pgd operator image name
*/}}
{{- define "edb-postgres-distributed-for-kubernetes.operatorImageName" }}
{{- if .Values.image.repository }}
{{- printf "%s/%s:%s" .Values.image.repository  ( .Values.image.imageName | default "pg4k-pgd" ) ( .Values.image.imageTag | default .Chart.AppVersion ) }}
{{- else }}
{{- printf "%s/%s:%s" .Values.global.repository  ( .Values.image.imageName | default "pg4k-pgd" )  ( .Values.image.imageTag | default .Chart.AppVersion ) }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "edb-postgres-distributed-for-kubernetes.labels" -}}
helm.sh/chart: {{ include "edb-postgres-distributed-for-kubernetes.chart" . }}
{{ include "edb-postgres-distributed-for-kubernetes.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "edb-postgres-distributed-for-kubernetes.selectorLabels" -}}
app.kubernetes.io/name: pgd-operator
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "edb-postgres-distributed-for-kubernetes.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "edb-postgres-distributed-for-kubernetes.fullname" .) .Values.serviceAccount.name }}
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

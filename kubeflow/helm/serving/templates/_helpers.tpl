{{/*
Expand the name of the chart.
*/}}
{{- define "serving.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "serving.fullname" -}}
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
{{- define "serving.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "serving.labels" -}}
helm.sh/chart: {{ include "serving.chart" . }}
{{ include "serving.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "serving.selectorLabels" -}}
app: {{ include "serving.name" . }}
app.kubernetes.io/name: {{ include "serving.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Controller selector labels
*/}}
{{- define "serving.controllerSelectorLabels" -}}
app: {{ include "serving.name" . }}-controller
app.kubernetes.io/name: {{ include "serving.name" . }}-controller
app.kubernetes.io/instance: {{ .Release.Name }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "serving.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "serving.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

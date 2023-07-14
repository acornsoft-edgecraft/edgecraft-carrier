{{/*
chart name
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
define namespace
default: gitlab
*/}}
{{- define "namespace" -}}
{{- default "gitlab" .Values.namespace | trunc 63 | trimSuffix "-"  -}}
{{- end -}}

{{/*
app name
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
persistent volumes
*/}}
{{- define "pvdata" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name "data" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pvlog" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name "log" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pvconfig" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name "config" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
persistent volume claims
*/}}
{{- define "pvcdata" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name "data" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pvclog" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name "log" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pvcconfig" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name "config" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
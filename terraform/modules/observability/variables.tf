variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "release_name" {
  description = "Helm release name for kube-prometheus-stack."
  type        = string
  default     = "kube-prometheus-stack"
}

variable "namespace" {
  description = "Kubernetes namespace where the monitoring stack is installed."
  type        = string
  default     = "monitoring"
}

variable "repository" {
  description = "Helm repository containing kube-prometheus-stack."
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "chart" {
  description = "Helm chart name."
  type        = string
  default     = "kube-prometheus-stack"
}

variable "chart_version" {
  description = "Pinned Helm chart version."
  type        = string
  default     = "91.5.1"
}
variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name used by the Pod Identity association."
  type        = string
}

variable "secret_name" {
  description = "AWS Secrets Manager name for the GitHub App credentials."
  type        = string
  default     = "nexpay/dev/argocd/github-app"
}

variable "iam_role_name" {
  description = "IAM role name used by External Secrets Operator."
  type        = string
  default     = "nexpay-external-secrets"
}

variable "namespace" {
  description = "Kubernetes namespace where External Secrets Operator is installed."
  type        = string
  default     = "external-secrets"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount used by External Secrets Operator."
  type        = string
  default     = "external-secrets"
}

variable "helm_release_name" {
  description = "Helm release name for External Secrets Operator."
  type        = string
  default     = "external-secrets"
}

variable "helm_repository" {
  description = "Helm repository containing External Secrets Operator."
  type        = string
  default     = "https://charts.external-secrets.io"
}

variable "helm_chart" {
  description = "Helm chart name for External Secrets Operator."
  type        = string
  default     = "external-secrets"
}

variable "helm_chart_version" {
  description = "Pinned External Secrets Operator Helm chart version."
  type        = string
  default     = "2.11.0"
}

variable "bootstrap_manifests" {
  description = "Kubernetes manifests that must be bootstrapped with the External Secrets Operator."
  type        = any
  default     = []
}
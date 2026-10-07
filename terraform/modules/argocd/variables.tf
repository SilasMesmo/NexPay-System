variable "release_name" {
  description = "Helm release name for Argo CD."
  type        = string
  default     = "argocd"
}

variable "namespace" {
  description = "Kubernetes namespace where Argo CD will be installed."
  type        = string
  default     = "argocd"
}

variable "repository" {
  description = "Helm repository containing the Argo CD chart."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart" {
  description = "Helm chart name for Argo CD."
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Pinned Argo CD Helm chart version."
  type        = string
  default     = "10.9.2"
}

variable "bootstrap_manifests" {
  description = "Lista de manifestos para o bootstrap do ArgoCD"
  type        = any
  default     = []
}
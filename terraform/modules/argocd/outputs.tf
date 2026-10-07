output "release_name" {
  description = "Argo CD Helm release name."
  value       = helm_release.argocd.name
}

output "namespace" {
  description = "Kubernetes namespace where Argo CD is installed."
  value       = helm_release.argocd.namespace
}

output "chart_version" {
  description = "Installed Argo CD Helm chart version."
  value       = helm_release.argocd.version
}
output "release_name" {
  description = "Helm release name."
  value       = helm_release.kube_prometheus_stack.name
}

output "namespace" {
  description = "Kubernetes namespace containing the monitoring stack."
  value       = helm_release.kube_prometheus_stack.namespace
}

output "chart_version" {
  description = "Installed kube-prometheus-stack chart version."
  value       = helm_release.kube_prometheus_stack.version
}

output "opentelemetry_collector_release_name" {
  description = "OpenTelemetry Collector Helm release name."
  value       = helm_release.opentelemetry_collector.name
}

output "opentelemetry_collector_chart_version" {
  description = "OpenTelemetry Collector Helm chart version."
  value       = helm_release.opentelemetry_collector.version
}
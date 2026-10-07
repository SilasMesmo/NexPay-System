resource "helm_release" "kube_prometheus_stack" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true

  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  wait    = true
  atomic  = true
  timeout = 900

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "opentelemetry_collector" {
  name             = "opentelemetry-collector"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.173.1"

  wait    = true
  atomic  = true
  timeout = 900

  values = [
    file("${path.module}/otel-values.yaml")
  ]

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
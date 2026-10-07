resource "helm_release" "argocd" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true

  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  wait    = true
  atomic  = true
  timeout = 900
}
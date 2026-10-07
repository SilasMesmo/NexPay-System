output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.nexpay_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS Kubernetes API"
  value       = aws_eks_cluster.nexpay_cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded CA certificate of the EKS cluster"
  value       = aws_eks_cluster.nexpay_cluster.certificate_authority[0].data
}
output "secret_arn" {
  description = "ARN of the AWS Secrets Manager secret used for Argo CD GitHub App credentials."
  value       = aws_secretsmanager_secret.github_app.arn
}

output "secret_name" {
  description = "Name of the AWS Secrets Manager secret."
  value       = aws_secretsmanager_secret.github_app.name
}

output "iam_role_arn" {
  description = "IAM role ARN used by External Secrets Operator."
  value       = aws_iam_role.external_secrets.arn
}

output "pod_identity_association_arn" {
  description = "EKS Pod Identity association ARN."
  value       = aws_eks_pod_identity_association.external_secrets.association_arn
}

output "helm_release_name" {
  description = "External Secrets Operator Helm release name."
  value       = helm_release.external_secrets.name
}

output "helm_chart_version" {
  description = "External Secrets Operator Helm chart version."
  value       = helm_release.external_secrets.version
}
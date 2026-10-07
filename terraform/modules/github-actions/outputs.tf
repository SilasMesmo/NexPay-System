output "oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC identity provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "ci_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions CI"
  value       = aws_iam_role.github_actions_ci.arn
}

output "ecr_push_policy_arn" {
  description = "ARN of the policy allowing GitHub Actions to push images to ECR"
  value       = aws_iam_policy.ecr_push.arn
}
output "repository_urls" {
  description = "ECR repository URLs"
  value = {
    for name, repository in aws_ecr_repository.images_repo :
    name => repository.repository_url
  }
}

output "repository_arns" {
  description = "ARNs of the ECR repositories"
  value = {
    for name, repository in aws_ecr_repository.images_repo :
    name => repository.arn
  }
}
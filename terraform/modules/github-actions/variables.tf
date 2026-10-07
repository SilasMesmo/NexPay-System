variable "role_name" {
  description = "IAM role assumed by GitHub Actions"
  type        = string
}

variable "github_repository_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repository_name" {
  description = "GitHub repository name"
  type        = string
}

variable "github_repository_owner_id" {
  description = "Immutable GitHub repository owner ID"
  type        = string
}

variable "github_repository_id" {
  description = "Immutable GitHub repository ID"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the CI role"
  type        = string
  default     = "main"
}

variable "ecr_repository_arns" {
  description = "ARNs of ECR repositories that GitHub Actions can push to"
  type        = map(string)
}
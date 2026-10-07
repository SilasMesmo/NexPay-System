resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name      = "github-actions-oidc"
    Project   = "nexpay"
    ManagedBy = "terraform"
    Purpose   = "github-actions-identity"
  }
}

# IAM
resource "aws_iam_role" "github_actions_ci" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repository_owner}@${var.github_repository_owner_id}/${var.github_repository_name}@${var.github_repository_id}:ref:refs/heads/${var.github_branch}"

            "token.actions.githubusercontent.com:repository_owner_id" = var.github_repository_owner_id

            "token.actions.githubusercontent.com:repository_id" = var.github_repository_id

            "token.actions.githubusercontent.com:ref" = "refs/heads/${var.github_branch}"
          }
        }
      }
    ]
  })

  tags = {
    Name      = var.role_name
    Project   = "nexpay"
    ManagedBy = "terraform"
    Purpose   = "github-actions-ci"
  }
}

resource "aws_iam_policy" "ecr_push" {
  name        = "${var.role_name}-ecr-push"
  description = "Allow GitHub Actions CI to authenticate and push NexPay images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthorization"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Sid    = "ECRPushImages"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = values(var.ecr_repository_arns)
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_push" {
  role       = aws_iam_role.github_actions_ci.name
  policy_arn = aws_iam_policy.ecr_push.arn
}
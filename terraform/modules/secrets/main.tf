data "aws_iam_policy_document" "pod_identity_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

data "aws_iam_policy_document" "secrets_manager_access" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = [
      aws_secretsmanager_secret.github_app.arn
    ]
  }
}

resource "aws_secretsmanager_secret" "github_app" {
  name        = var.secret_name
  description = "NexPay GitHub App credentials for Argo CD repository access"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Component   = "argocd"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role" "external_secrets" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Component   = "external-secrets"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy" "external_secrets" {
  name   = "${var.iam_role_name}-secrets-manager"
  role   = aws_iam_role.external_secrets.id
  policy = data.aws_iam_policy_document.secrets_manager_access.json
}

resource "helm_release" "external_secrets" {
  name             = var.helm_release_name
  namespace        = var.namespace
  create_namespace = true

  repository = var.helm_repository
  chart      = var.helm_chart
  version    = var.helm_chart_version

  wait    = true
  atomic  = true
  timeout = 900

  set = [
  {
    name  = "installCRDs"
    value = "true"
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }
]

  values = [
    yamlencode({
      extraObjects = var.bootstrap_manifests
    })
  ] 
}

resource "aws_eks_pod_identity_association" "external_secrets" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.external_secrets.arn
}
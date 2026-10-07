module "vpc" {
  source = "../../modules/vpc"

  vpc_name               = var.vpc_name
  cidr_block             = var.vpc_cidr_block
  public_subnets         = var.public_subnets
  environment            = var.environment
  private_app_subnets    = var.private_app_subnets
  private_data_subnets   = var.private_data_subnets
  project_name           = var.project_name
  aws_region             = var.aws_region  
  analytics_queue_arn    = module.messaging.analytics_queue_arn
  notification_queue_arn = module.messaging.notification_queue_arn
  fraud_queue_arn        = module.messaging.fraud_queue_arn
}

module "eks" {
  source  = "../../modules/eks"

  node_groups            = var.node_groups
  cluster_name           = var.cluster_name
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  analytics_queue_arn    = module.messaging.analytics_queue_arn
  notification_queue_arn = module.messaging.notification_queue_arn
  fraud_queue_arn        = module.messaging.fraud_queue_arn
}

module "rds" {
  source  = "../../modules/rds"

  db_name                 = var.db_name
  environment             = var.environment
  private_data_subnet_ids = module.vpc.private_data_subnet_ids
  security_group_id       = module.vpc.rds_security_group_id
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  allocated_storage    = var.rds_allocated_storage
  storage_type         = var.rds_storage_type
  database_name        = var.rds_database_name
  master_username      = var.rds_master_username
}

module "cache" {
  source = "../../modules/cache"

  cache_name               = var.cache_name
  environment              = var.environment
  private_data_subnet_ids  = module.vpc.private_data_subnet_ids
  security_group_id        = module.vpc.redis_security_group_id
  engine_version           = var.cache_engine_version
  node_type                = var.cache_node_type
  num_cache_clusters       = var.cache_num_cache_clusters
}

module "messaging" {
  source  = "../../modules/messaging"

  messaging_name = var.messaging_name
  environment    = var.environment
}

module "ecr" {
  source   = "../../modules/ecr"

  environment    = var.environment
  project_name   = var.project_name
  repositories   = [
    "payments",
    "frontend"
    ]
}

module "github_actions" {
  source = "../../modules/github-actions"

  role_name = var.github_actions_role_name
  github_repository_owner    = var.github_repository_owner
  github_repository_name     = var.github_repository_name
  github_repository_owner_id = var.github_repository_owner_id
  github_repository_id       = var.github_repository_id
  github_branch              = var.github_branch
  ecr_repository_arns        = module.ecr.repository_arns
}

module "argocd" {
  source = "../../modules/argocd"

  release_name  = "argocd"
  namespace     = "argocd"
  repository    = "https://argoproj.github.io/argo-helm"
  chart         = "argo-cd"
  chart_version = "10.9.2"

  bootstrap_manifests = [
    yamldecode(file("../../../argocd/applications/payments-dev.yaml")),
    yamldecode(file("../../../argocd/applications/payments-stg.yaml")),
    yamldecode(file("../../../argocd/applications/payments-prd.yaml"))
  ]

  depends_on = [
    module.eks,
    module.secrets
  ]
}

module "secrets" {
  source = "../../modules/secrets"

  project_name = var.project_name
  environment  = var.environment
  cluster_name = module.eks.cluster_name

  bootstrap_manifests = [
    yamldecode(file("../../../argocd/secrets/aws-secretsmanager.yaml")),
    yamldecode(file("../../../argocd/secrets/github-repository.yaml"))
  ]

  depends_on = [
    module.eks
  ]
}

module "observability" {
  source = "../../modules/observability"

  project_name = var.project_name
  environment  = var.environment

  release_name  = "kube-prometheus-stack"
  namespace     = "monitoring"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "kube-prometheus-stack"
  chart_version = "91.5.1"

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.14.0"

  values = [
    file("${path.root}/../../modules/eks/helm/aws-load-balancer-controller-values.yaml")
  ]

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    }
  ]

  depends_on = [
    module.eks
  ]
}
# EKS IAM
  # eks.amazonaws.com
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-cluster-role"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# ec2.amazonaws.com
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-node-role"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_pull_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.eks_node_role.name
}

# pods.eks.amazonaws.com
resource "aws_iam_role" "vpc_cni_role" {
  name = "${var.cluster_name}-vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-vpc-cni-role"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_role.name
}

resource "aws_iam_role" "load_balancer_controller_role" {
  name = "${var.cluster_name}-load-balancer-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-load-balancer-controller-role"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "load_balancer_controller_policy" {
  name        = "${var.cluster_name}-load-balancer-controller-policy"
  description = "IAM policy for the AWS Load Balancer Controller"

  policy = file("${path.module}/iam-policy.json")

  tags = {
    Name        = "${var.cluster_name}-load-balancer-controller-policy"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller_policy" {
  policy_arn = aws_iam_policy.load_balancer_controller_policy.arn
  role       = aws_iam_role.load_balancer_controller_role.name
}

resource "aws_eks_pod_identity_association" "vpc_cni" {
  cluster_name    = aws_eks_cluster.nexpay_cluster.name
  namespace       = "kube-system"
  service_account = "aws-node"
  role_arn        = aws_iam_role.vpc_cni_role.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.vpc_cni_policy_attachment
  ]
}

resource "aws_eks_pod_identity_association" "load_balancer_controller" {
  cluster_name    = aws_eks_cluster.nexpay_cluster.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.load_balancer_controller_role.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.load_balancer_controller_policy
  ]
}

# Role to pull queues
resource "aws_iam_role" "nexpay_app_role" {
  name = "${var.cluster_name}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

#  Allow access in SQS queues
resource "aws_iam_policy" "sqs_app_policy" {
  name        = "${var.cluster_name}-sqs-app-policy"
  description = "Permite que a aplicacao acesse as filas SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage",
        ]
        Resource = [
          var.fraud_queue_arn,
          var.analytics_queue_arn,
          var.notification_queue_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_app_policy_attach" {
  policy_arn = aws_iam_policy.sqs_app_policy.arn
  role       = aws_iam_role.nexpay_app_role.name
}

resource "aws_eks_pod_identity_association" "nexpay_app" {
  cluster_name    = aws_eks_cluster.nexpay_cluster.name
  namespace       = "nexpay-${var.environment}"
  service_account = "sa-pod-perform"
  role_arn        = aws_iam_role.nexpay_app_role.arn

  depends_on = [aws_eks_addon.pod_identity_agent]
}

# CLUSTER
resource "aws_eks_cluster" "nexpay_cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster_role.arn
  bootstrap_self_managed_addons = false

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids = values(var.private_app_subnet_ids)

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = var.cluster_name
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment
  ]
}

resource "aws_eks_node_group" "managed" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.nexpay_cluster.name
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = values(var.private_app_subnet_ids)

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  scaling_config {
    min_size     = each.value.min_size
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${var.cluster_name}-${each.key}"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    NodeGroup   = each.key
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.ecr_pull_policy
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.nexpay_cluster.name
  addon_name   = "vpc-cni"

  depends_on = [
    aws_eks_node_group.managed,
    aws_eks_pod_identity_association.vpc_cni
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.nexpay_cluster.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [
    aws_eks_node_group.managed
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.nexpay_cluster.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_node_group.managed
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.nexpay_cluster.name
  addon_name   = "kube-proxy"

  depends_on = [
    aws_eks_node_group.managed
  ]
}
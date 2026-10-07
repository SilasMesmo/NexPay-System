#VPC
resource "aws_vpc" "vpc_nexpay" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_name
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# SUBNETS
#  PUBLIC
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.vpc_nexpay.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name            = "${var.vpc_name}-${each.key}"
    Project         = "nexpay"
    Environment     = var.environment
    ManagedBy       = "terraform"
    Tier            = "public"
  }
}

#  PRIVATE
resource "aws_subnet" "private_app" {
  for_each = var.private_app_subnets

  vpc_id            = aws_vpc.vpc_nexpay.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name        = "${var.vpc_name}-${each.key}"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-app"
  }
}

resource "aws_subnet" "private_data" {
  for_each = var.private_data_subnets

  vpc_id            = aws_vpc.vpc_nexpay.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name        = "${var.vpc_name}-${each.key}"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-data"
  }
}

# IGW
resource "aws_internet_gateway" "nexpay_igw" {
  vpc_id = aws_vpc.vpc_nexpay.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# ROUTES
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_nexpay.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nexpay_igw.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "public"
  }
}

resource "aws_route_table" "private_app_rt" {
  for_each = aws_subnet.private_app

  vpc_id = aws_vpc.vpc_nexpay.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = local.nat_gateway_by_az[each.value.availability_zone]
  }

  tags = {
    Name        = "${var.vpc_name}-${each.key}-rt"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-app"
  }
}

resource "aws_route_table" "private_data_rt" {
  for_each = aws_subnet.private_data

  vpc_id = aws_vpc.vpc_nexpay.id

  tags = {
    Name        = "${var.vpc_name}-${each.key}-rt"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-data"
  }
}

# ROUTE ASSOCIATION
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app_rt[each.key].id
}

resource "aws_route_table_association" "private_data" {
  for_each = aws_subnet.private_data

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_data_rt[each.key].id
}

# IPs
resource "aws_eip" "nat_ip" {
  for_each = aws_subnet.public

  domain = "vpc"

  tags = {
    Name        = "${var.vpc_name}-${each.key}-nat-eip"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "public"
  }
}

# NAT
resource "aws_nat_gateway" "public_nat" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat_ip[each.key].id
  subnet_id     = each.value.id

  connectivity_type = "public"

  tags = {
    Name        = "${var.vpc_name}-${each.key}-nat"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "public"
  }
}

locals {
  nat_gateway_by_az = {
    for subnet_key, subnet in var.public_subnets :
    subnet.availability_zone => aws_nat_gateway.public_nat[subnet_key].id
  }
}

# VPC ENDPOINT

data "aws_region" "sqs_point" {}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.services

  vpc_id = aws_vpc.vpc_nexpay.id

  service_name = "com.amazonaws.${var.aws_region}.${each.value}"

  vpc_endpoint_type = "Interface"

 subnet_ids = [for subnet in aws_subnet.private_app : subnet.id]

  security_group_ids = [aws_security_group.vpc_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpce-${replace(each.value, ".", "-")}"
    Project     = var.project_name
    Environment = var.environment
    Service     = each.value
    ManagedBy   = "Terraform"
  }
}

data "aws_iam_policy_document" "sqs_vpc_endpoint" {
  statement {
    sid    = "AllowSQSAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:SendMessageBatch"
    ]

    resources = [var.fraud_queue_arn, 
                 var.analytics_queue_arn, 
                 var.notification_queue_arn
                ]
  }
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id            = aws_vpc.vpc_nexpay.id
  service_name      = "com.amazonaws.${var.aws_region}.sqs"
  vpc_endpoint_type = "Interface"

  subnet_ids = [for subnet in aws_subnet.private_app : subnet.id]

  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  private_dns_enabled = true

  policy = data.aws_iam_policy_document.sqs_vpc_endpoint.json

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpce-sqs"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
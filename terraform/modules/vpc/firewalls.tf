# VPC ENDPOINTS
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.vpc_name}-vpce-sg"
  description = "Security group para os VPC Endpoints (SQS, ECR, etc)"
  vpc_id      = aws_vpc.vpc_nexpay.id

  tags = {
    Name        = "${var.vpc_name}-vpce-sg"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-app"
  }
}

# HTTPS
resource "aws_vpc_security_group_ingress_rule" "vpce_https" {
  for_each = {
    for subnet_key, subnet in var.private_app_subnets :
    subnet_key => subnet.cidr_block
  }

  security_group_id = aws_security_group.vpc_endpoints.id

  cidr_ipv4   = each.value
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "HTTPS access to VPC Endpoints from ${each.key}"
}


# RDS
resource "aws_security_group" "rds" {
  name        = "${var.vpc_name}-rds-sg"
  description = "Security group for NexPay RDS PostgreSQL"
  vpc_id      = aws_vpc.vpc_nexpay.id

  tags = {
    Name        = "${var.vpc_name}-rds-sg"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-data"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_postgres" {
  for_each = {
    for subnet_key, subnet in var.private_app_subnets :
    subnet_key => subnet.cidr_block
  }

  security_group_id = aws_security_group.rds.id

  cidr_ipv4   = each.value
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "PostgreSQL access from ${each.key}"
}

# CACHE/REDIS
resource "aws_security_group" "redis" {
  name        = "${var.vpc_name}-redis-sg"
  description = "Security group for NexPay Redis cache"
  vpc_id      = aws_vpc.vpc_nexpay.id

  tags = {
    Name        = "${var.vpc_name}-redis-sg"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "private-data"
  }
}

resource "aws_vpc_security_group_ingress_rule" "redis" {
  for_each = {
    for subnet_key, subnet in var.private_app_subnets :
    subnet_key => subnet.cidr_block
  }

  security_group_id = aws_security_group.redis.id

  cidr_ipv4   = each.value
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"

  description = "Redis access from ${each.key}"
}
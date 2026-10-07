resource "aws_elasticache_subnet_group" "nexpay_cache" {
  name        = "${var.cache_name}-subnet-group"
  description = "Subnet group for the NexPay cache"

  subnet_ids = values(var.private_data_subnet_ids)

  tags = {
    Name        = "${var.cache_name}-subnet-group"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_elasticache_replication_group" "nexpay_redis" {
  replication_group_id = var.cache_name
  description          = "NexPay Redis cache replication group"

  engine         = "redis"
  engine_version = var.engine_version
  node_type      = var.node_type

  port = 6379

  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = true
  multi_az_enabled           = true

  subnet_group_name = aws_elasticache_subnet_group.nexpay_cache.name

  security_group_ids = [
    var.security_group_id
  ]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = {
    Name        = var.cache_name
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
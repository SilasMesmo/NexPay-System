output "primary_endpoint" {
  description = "Primary endpoint of the Redis replication group"
  value       = aws_elasticache_replication_group.nexpay_redis.primary_endpoint_address
}

output "reader_endpoint" {
  description = "Reader endpoint of the Redis replication group"
  value       = aws_elasticache_replication_group.nexpay_redis.reader_endpoint_address
}

output "port" {
  description = "Port used by the Redis replication group"
  value       = aws_elasticache_replication_group.nexpay_redis.port
}
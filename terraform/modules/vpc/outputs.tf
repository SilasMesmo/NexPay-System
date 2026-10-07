output "vpc_id" {
  type        = string
  description = "ID of the NexPay VPC"
  value       = aws_vpc.vpc_nexpay.id
}

output "public_subnet_ids" {
  type = map(string)

  description = "IDs of the public subnets"

  value = {
    for subnet_key, subnet in aws_subnet.public :
    subnet_key => subnet.id
  }
}

output "private_app_subnet_ids" {
  type = map(string)

  description = "IDs of the private application subnets"

  value = {
    for subnet_key, subnet in aws_subnet.private_app :
    subnet_key => subnet.id
  }
}

output "private_data_subnet_ids" {
  type = map(string)

  description = "IDs of the private data subnets"

  value = {
    for subnet_key, subnet in aws_subnet.private_data :
    subnet_key => subnet.id
  }
}

output "rds_security_group_id" {
  description = "Security group ID used by the RDS database"
  value       = aws_security_group.rds.id
}

output "redis_security_group_id" {
  description = "Security group ID used by the Redis cache"
  value       = aws_security_group.redis.id
}
output "db_endpoint" {
  description = "DNS endpoint of the NexPay PostgreSQL database"
  value       = aws_db_instance.nexpay_postgres.address
}

output "db_port" {
  description = "Port used by the NexPay PostgreSQL database"
  value       = aws_db_instance.nexpay_postgres.port
}

output "db_name" {
  description = "Name of the NexPay PostgreSQL database"
  value       = aws_db_instance.nexpay_postgres.db_name
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS master credentials"
  value       = aws_db_instance.nexpay_postgres.master_user_secret[0].secret_arn
  sensitive   = true
}
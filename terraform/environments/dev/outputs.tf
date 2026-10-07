output "vpc_id" {
  description = "ID of the NexPay VPC"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Name of the NexPay EKS cluster"
  value       = module.eks.cluster_name
}

output "rds_endpoint" {
  description = "Endpoint of the NexPay PostgreSQL database"
  value       = module.rds.db_endpoint
}

output "payment_events_topic_arn" {
  description = "ARN of the NexPay payment events SNS topic"
  value       = module.messaging.payment_events_topic_arn
}
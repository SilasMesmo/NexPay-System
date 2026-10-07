output "payment_events_topic_arn" {
  description = "ARN of the payment events SNS topic"
  value       = aws_sns_topic.payment_events.arn
}

output "fraud_queue_arn" {
  description = "ARN of the fraud processing SQS queue"
  value       = aws_sqs_queue.fraud.arn
}

output "fraud_queue_url" {
  description = "URL of the fraud processing SQS queue"
  value       = aws_sqs_queue.fraud.url
}

output "notification_queue_arn" {
  description = "ARN of the notification processing SQS queue"
  value       = aws_sqs_queue.notification.arn
}

output "notification_queue_url" {
  description = "URL of the notification processing SQS queue"
  value       = aws_sqs_queue.notification.url
}

output "analytics_queue_arn" {
  description = "ARN of the analytics processing SQS queue"
  value       = aws_sqs_queue.analytics.arn
}

output "analytics_queue_url" {
  description = "URL of the analytics processing SQS queue"
  value       = aws_sqs_queue.analytics.url
}
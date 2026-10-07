#SNS -> Topics
resource "aws_sns_topic" "payment_events" {
  name = "${var.messaging_name}-payment-events"

  tags = {
    Name        = "${var.messaging_name}-payment-events"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "fraud" {
  topic_arn = aws_sns_topic.payment_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fraud.arn

  raw_message_delivery = true
}

resource "aws_sns_topic_subscription" "notification" {
  topic_arn = aws_sns_topic.payment_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.notification.arn

  raw_message_delivery = true
}

resource "aws_sns_topic_subscription" "analytics" {
  topic_arn = aws_sns_topic.payment_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.analytics.arn

  raw_message_delivery = true
}

# Fila Fraud
resource "aws_sqs_queue" "fraud" {
  name = "${var.messaging_name}-fraud"

  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20

  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.fraud_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Name        = "${var.messaging_name}-fraud"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "fraud-processing"
  }
}

# DLQ Fraud
resource "aws_sqs_queue" "fraud_dlq" {
  name = "${var.messaging_name}-fraud-dlq"

  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true

  tags = {
    Name        = "${var.messaging_name}-fraud-dlq"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "fraud-dead-letter"
  }
}

resource "aws_sqs_queue_policy" "fraud" {
  queue_url = aws_sqs_queue.fraud.url

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowPaymentEventsTopic"
        Effect = "Allow"

        Principal = {
          Service = "sns.amazonaws.com"
        }

        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.fraud.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.payment_events.arn
          }
        }
      }
    ]
  })
}

# Fila Notificação
resource "aws_sqs_queue" "notification" {
  name = "${var.messaging_name}-notification"

  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20

  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notification_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Name        = "${var.messaging_name}-notification"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "notification-processing"
  }
}

# DLQ Notificação
resource "aws_sqs_queue" "notification_dlq" {
  name = "${var.messaging_name}-notification-dlq"

  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true

  tags = {
    Name        = "${var.messaging_name}-notification-dlq"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "notification-dead-letter"
  }
}

resource "aws_sqs_queue_policy" "notification" {
  queue_url = aws_sqs_queue.notification.url

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowPaymentEventsTopic"
        Effect = "Allow"

        Principal = {
          Service = "sns.amazonaws.com"
        }

        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.notification.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.payment_events.arn
          }
        }
      }
    ]
  })
}

# Fila Analytics
resource "aws_sqs_queue" "analytics" {
  name = "${var.messaging_name}-analytics"

  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20

  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.analytics_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Name        = "${var.messaging_name}-analytics"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "analytics-processing"
  }
}

# DLQ Analytics
resource "aws_sqs_queue" "analytics_dlq" {
  name = "${var.messaging_name}-analytics-dlq"

  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true

  tags = {
    Name        = "${var.messaging_name}-analytics-dlq"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "analytics-dead-letter"
  }
}

resource "aws_sqs_queue_policy" "analytics" {
  queue_url = aws_sqs_queue.analytics.url

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowPaymentEventsTopic"
        Effect = "Allow"

        Principal = {
          Service = "sns.amazonaws.com"
        }

        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.analytics.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.payment_events.arn
          }
        }
      }
    ]
  })
}
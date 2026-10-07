variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.36"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will run"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs used by the EKS cluster"
  type        = map(string)
}

variable "node_groups" {
  description = "Managed node groups for the EKS cluster"

  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    min_size       = number
    desired_size   = number
    max_size       = number
    disk_size      = number
  }))
}

variable "fraud_queue_arn" {
  type        = string
}

variable "analytics_queue_arn" {
  type        = string
}

variable "notification_queue_arn" {
  type        = string
}
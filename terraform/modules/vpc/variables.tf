variable "vpc_name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the dev environment"
  type        = string
}


variable "environment" {
  description = "dev, stg, prd"
  type        = string
}

variable "project_name" {
  type        = string
  description = "description"
}


variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets to create in the VPC"
  type = map(object({
    availability_zone = string
    cidr_block        = string
  }))
}

variable "private_app_subnets" {
  description = "Private application subnets to create in the VPC"
  type = map(object({
    availability_zone = string
    cidr_block        = string
  }))
}

variable "private_data_subnets" {
  description = "Private data subnets to create in the VPC"
  type = map(object({
    availability_zone = string
    cidr_block        = string
  }))
}

variable "services" {
  type        = set(string)
  default     = [
    "ecr.api",
    "ecr.dkr",
    "sts",
    "logs",
    "ec2"
  ]
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
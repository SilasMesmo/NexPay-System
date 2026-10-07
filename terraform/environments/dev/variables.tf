variable "aws_region" {
  description = "AWS region for the dev environment"
  type        = string
}

variable "environment" {
  description = "dev, stg, prd"
  type        = string
}

# VPC -----------------------------------------------------------------------------------
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets for the VPC"
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

# EKS ------------------------------------------------------------------------------------ 
variable "node_groups" {
  description = "Managed node groups for the dev EKS cluster"

  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    min_size       = number
    desired_size   = number
    max_size       = number
    disk_size      = number
  }))
}

variable "cluster_name" {
  type        = string
  description = "cluster name"
}

#RDS ---------------------------------------------------------------------------------
variable "db_name" {
  description = "RDS instance identifier"
  type        = string
}

variable "rds_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "Initial RDS storage size in GiB"
  type        = number
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
}

variable "rds_database_name" {
  description = "Initial PostgreSQL database name"
  type        = string
}

variable "rds_master_username" {
  description = "RDS master username"
  type        = string
}

# CACHE REDIS ----------------------------------------------------------------------------
variable "cache_name" {
  description = "ElastiCache replication group identifier"
  type        = string
}

variable "cache_engine_version" {
  description = "Redis engine version"
  type        = string
}

variable "cache_node_type" {
  description = "ElastiCache node type"
  type        = string
}

variable "cache_num_cache_clusters" {
  description = "Number of cache nodes in the replication group"
  type        = number
}

# MESSAGING ----------------------------------------------------------------------------------
variable "messaging_name" {
  description = "Name prefix for NexPay messaging resources"
  type        = string
}

# ECR ----------------------------------------------------------------------------------------
variable "project_name" {
  description = "Project name"
  type        = string
}

# GITHUB --------------------------------------------------------------------------------------

variable "github_repository_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repository_name" {
  description = "GitHub repository name"
  type        = string
}

variable "github_repository_owner_id" {
  description = "Immutable GitHub repository owner ID"
  type        = string # 187827859
}

variable "github_repository_id" {
  description = "Immutable GitHub repository ID"
  type        = string # 1385773023
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the CI role"
  type        = string
  default     = "main"
}

variable "github_actions_role_name" {
  description = "Role name"
  type        = string
}
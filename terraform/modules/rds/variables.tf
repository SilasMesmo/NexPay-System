variable "db_name" {
  description = "Name of the NexPay database"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "private_data_subnet_ids" {
  description = "Private data subnet IDs used by the RDS subnet group"
  type        = map(string)
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Initial storage size in GiB"
  type        = number
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "database_name" {
  description = "Initial database name"
  type        = string
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID used by the RDS database"
  type        = string
}
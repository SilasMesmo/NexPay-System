variable "cache_name" {
  description = "Name of the NexPay cache"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "private_data_subnet_ids" {
  description = "Private data subnet IDs used by ElastiCache"
  type        = map(string)
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID used by the cache"
  type        = string
}

variable "num_cache_clusters" {
  description = "Number of cache nodes in the replication group"
  type        = number
}
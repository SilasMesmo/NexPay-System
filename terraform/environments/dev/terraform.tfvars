aws_region     = "us-east-1"

vpc_name       = "nexpay-dev-vpc"
vpc_cidr_block = "10.0.0.0/16"
environment    = "dev"

# PUBLIC SUBNET
public_subnets = {
  public_a = {
    availability_zone = "us-east-1a"
    cidr_block        = "10.0.1.0/24"
  }

  public_b = {
    availability_zone = "us-east-1b"
    cidr_block        = "10.0.2.0/24"
  }
}

# PRIVATE SUBNET
private_app_subnets = {
  private_app_a = {
    availability_zone = "us-east-1a"
    cidr_block        = "10.0.11.0/24"
  }

  private_app_b = {
    availability_zone = "us-east-1b"
    cidr_block        = "10.0.12.0/24"
  }
}

# PRIVATE DATA SUBNETS
private_data_subnets = {
  private_data_a = {
    availability_zone = "us-east-1a"
    cidr_block        = "10.0.21.0/24"
  }

  private_data_b = {
    availability_zone = "us-east-1b"
    cidr_block        = "10.0.22.0/24"
  }
}

# CLUSTER

cluster_name = "nexpay-dev-eks"

node_groups = {
  system = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"

    min_size     = 2
    desired_size = 2
    max_size     = 6

    disk_size = 30
  }
} 

# RDS

db_name = "nexpay-dev-postgres"

rds_engine_version    = "18.6"
rds_instance_class    = "db.t4g.medium"
rds_allocated_storage = 50
rds_storage_type      = "gp3"

rds_database_name = "nexpay"
rds_master_username = "nexpay_admin"

# REDIS CACHE

cache_name = "nexpay-dev-redis"

cache_engine_version     = "7.1"
cache_node_type          = "cache.t4g.micro"
cache_num_cache_clusters = 2

# MESSAGING

messaging_name = "nexpay-dev"

# ECR

project_name = "nexpay"

# GITHUB

github_repository_owner    = "SilasMesmo"
github_repository_name     = "NexPay-System"
github_repository_owner_id = ""
github_repository_id       = ""

github_branch = "main"

github_actions_role_name = "nexpay-github-actions-ci"
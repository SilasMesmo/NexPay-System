# attach ../vpc/main.tf line 50 aws_subnet.private_data.ids
resource "aws_db_subnet_group" "nexpay_db" {
  name        = "${var.db_name}-subnet-group"
  description = "DB subnet group for the NexPay database"

  subnet_ids = values(var.private_data_subnet_ids)

  tags = {
    Name        = "${var.db_name}-subnet-group"
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# DB Instance
resource "aws_db_instance" "nexpay_postgres" {
  identifier = var.db_name

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.database_name
  username = var.master_username

  manage_master_user_password = true

  multi_az             = true
  publicly_accessible  = false
  storage_encrypted    = true
  backup_retention_period = 7

  db_subnet_group_name = aws_db_subnet_group.nexpay_db.name
  vpc_security_group_ids = [
    var.security_group_id
  ]

  engine_lifecycle_support = "open-source-rds-extended-support-disabled"

  tags = {
    Name        = var.db_name
    Project     = "nexpay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
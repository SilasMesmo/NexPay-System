resource "aws_ecr_repository" "images_repo" {
  for_each = var.repositories

  name                 = "${var.project_name}/${var.environment}/${each.value}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "${var.project_name}/${var.environment}/${each.value}"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "container-registry"
  }
}
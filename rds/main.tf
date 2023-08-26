locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "rds"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = var.db_storage
  db_name                = var.db_name
  db_subnet_group_name   = var.db_subnet_group
  engine                 = "postgres"
  engine_version         = "13.12"
  identifier             = "${local.prefix}-rds-instance"
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = true
}
locals {
  vpc_cidr_block = "10.16.0.0/16"
  security_groups = {
    rds = {
      name        = "${var.project_name}-${terraform.workspace}-rds-sg"
      description = "Security group for RDS instance"
      ingress = {
        postgres = {
          from        = 5432
          to          = 5432
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr_block]
        }
      }
    }
  }
}
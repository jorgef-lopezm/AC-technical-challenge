locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "rds"
  }
}
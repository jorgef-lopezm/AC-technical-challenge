locals {
  vpc_cidr_block = "10.16.0.0/16"
  prefix         = "${var.project_name}-${terraform.workspace}"
}
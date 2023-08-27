# Set prefix and common tags
locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "vpc"
    # Any additional tags add below:
  }
}
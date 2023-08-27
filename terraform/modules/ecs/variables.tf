variable "project_name" {
  type        = string
  description = "Name for the project in order to name the resources"
}

variable "ecr_image" {
  description = "ECR image for proxy"
  default     = "public.ecr.aws/w3w5l3i9/jorge-apache:latest"
}

variable "container_definitions_path" {

}

variable "db_host" {

}

variable "db_port" {

}

variable "db_name" {

}

variable "db_user" {

}

variable "db_pass" {

}

variable "subnets" {

}

variable "ecs_security_groups" {

}

variable "target_group" {

}

variable "lb_dns_name" {

}
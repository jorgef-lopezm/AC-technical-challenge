variable "project_name" {
  type        = string
  description = "Name for the project in order to name the resources"
}

variable "db_storage" {
  type        = string
  description = "Allocated storage in GB"
}

variable "db_name" {
  type        = string
  description = "Name of the database"
}

variable "db_subnet_group" {
  type        = string
  description = "Name of the subnet group for the database"
}

variable "db_instance_class" {
  type        = string
  description = "Instance type for the RDS instance"
}

variable "db_username" {
  type        = string
  description = "Username for the database"
}

variable "db_password" {
  type        = string
  description = "Password for the database"
}

variable "vpc_security_group_ids" {
  # type        = string
  description = "List of VPC security groups to associate"
}
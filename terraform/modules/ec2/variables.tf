variable "project_name" {
  type        = string
  description = "Name for the project in order to name the resources"
}

variable "user_data_path" {
  type        = string
  description = "Path for the user data template file"
}

variable "subnet" {
  type        = string
  description = "Subnet ID where the instance will be created"
}

variable "security_groups" {
  type        = list(string)
  description = "List of the security groups for the instance"
}
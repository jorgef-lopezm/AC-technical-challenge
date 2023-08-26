variable "project_name" {
  type        = string
  description = "Name for the project in order to name the resources"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of the CIDR blocks for public subnets (for resources needing internet access)"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of the CIDR blocks for private subnets (for resources not needing direct internet access)"
}

variable "security_groups" {

}
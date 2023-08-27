variable "project_name" {

}

variable "vpc_id" {

}

variable "alb_security_groups" {
  type        = list(string)
  description = "List of security groups for the ALB"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets where the ALB will be attached"
}
locals {
  vpc_cidr_block = "10.16.0.0/16"
  prefix         = "${var.project_name}-${terraform.workspace}"
  security_groups = [
    {
      name        = "${local.prefix}-rds-sg"
      description = "Security group for RDS instance running Postgres"
    }
  ]
}

# Creates the following: 
# - VPC
# - 2 public subnets - load balancer and bastion host
# - 2 private subnets - ecs service and RDS
# - IGW
# - NGW for each private subnet
# - Subnet group for the rds
# - RDS, bastion, ecs and load balancer security groups
module "vpc" {
  source          = "./modules/vpc"
  project_name    = var.project_name
  cidr_block      = local.vpc_cidr_block
  public_subnets  = ["10.16.0.0/20", "10.16.16.0/20"]
  private_subnets = ["10.16.32.0/20", "10.16.48.0/20"]
}

# Creates the following:
# - ec2 instance and installs docker from a user data
# - role for the bastion instance
module "ec2" {
  source          = "./modules/ec2"
  project_name    = var.project_name
  user_data_path  = "${path.root}/templates/ec2/user_data.tpl"
  subnet          = module.vpc.public_subnets[0]
  security_groups = module.vpc.bastion_security_group
}

# Created the following
# - rds instance with postgres 13.2
module "rds" {
  source                 = "./modules/rds"
  project_name           = var.project_name
  db_storage             = 10
  db_name                = var.db_name
  db_subnet_group        = module.vpc.db_subnet_group_name[0]
  db_username            = var.db_user
  db_password            = var.db_pass
  db_instance_class      = "db.t3.micro"
  vpc_security_group_ids = module.vpc.db_security_group
}

# Creates the following:
# - ECS Cluster
# - Task Execution Role - includes read permissions for ECR and write permissions for cloudwatch
# - Task role - no permissions attached
# - Cloudwatch log group
# - ECS task and service
module "ecs" {
  source                     = "./modules/ecs"
  project_name               = var.project_name
  container_definitions_path = "${path.root}/templates/task/container-definitions.json.tpl"
  subnets                    = module.vpc.private_subnets
  db_host                    = module.rds.db_endpoint
  db_port                    = 5432
  db_name                    = var.db_name
  db_user                    = var.db_user
  db_pass                    = var.db_pass
  ecs_security_groups        = module.vpc.ecs_security_group
  target_group               = module.alb.target_group_arn
  lb_dns_name                = module.alb.lb_dns_name
}

module "alb" {
  source              = "./modules/elb"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  alb_security_groups = module.vpc.lb_security_group
  subnets             = module.vpc.public_subnets
}
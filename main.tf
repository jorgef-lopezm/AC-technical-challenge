module "vpc" {
  source          = "./vpc"
  project_name    = var.project_name
  cidr_block      = local.vpc_cidr_block
  public_subnets  = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
  private_subnets = ["10.16.48.0/20", "10.16.64.0/20", "10.16.80.0/20"]
}

module "rds" {
  source                 = "./rds"
  project_name           = var.project_name
  db_storage             = 10
  db_name                = var.db_name
  db_subnet_group        = module.vpc.db_subnet_group_name[0]
  db_username            = var.db_user
  db_password            = var.db_pass
  db_instance_class      = "db.t3.micro"
  vpc_security_group_ids = module.vpc.db_security_group
}

module "ecs" {
  source       = "./ecs"
  project_name = var.project_name
}

module "ec2" {
  source          = "./ec2"
  project_name    = var.project_name
  user_data_path  = "${path.root}/templates/ec2/user_data.tpl"
  public_subnet   = module.vpc.public_subnets[0]
  security_groups = module.vpc.bastion_security_group
}

module "task" {
  source                     = "./task"
  project_name               = var.project_name
  container_definitions_path = "${path.root}/templates/task/container-definitions.json.tpl"
  db_host                    = module.rds.db_endpoint
  db_port                    = 5432
  db_name                    = var.db_name
  db_user                    = var.db_user
  db_pass                    = var.db_pass
  log_group_name             = module.ecs.log_group
  task_execution_role_arn    = module.ecs.task_execution_role
  task_role_arn              = module.ecs.task_role
  ecs_cluster                = module.ecs.ecs_cluster
  subnets                    = module.vpc.private_subnets
  ecs_security_groups        = module.vpc.ecs_security_group
  target_group               = module.alb.target_group_arn
}

module "alb" {
  source              = "./elb"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  alb_security_groups = module.vpc.lb_security_group
  subnets             = module.vpc.public_subnets
}
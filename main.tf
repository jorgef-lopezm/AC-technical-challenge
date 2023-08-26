module "vpc" {
  source          = "./vpc"
  project_name    = var.project_name
  cidr_block      = local.vpc_cidr_block
  public_subnets  = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
  private_subnets = ["10.16.48.0/20", "10.16.64.0/20", "10.16.80.0/20"]
  security_groups = local.security_groups
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
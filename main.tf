module "vpc" {
  source          = "./vpc"
  project_name    = var.project_name
  cidr_block      = "10.16.0.0/16"
  public_subnets  = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
  private_subnets = ["10.16.48.0/20", "10.16.64.0/20", "10.16.80.0/20"]
}
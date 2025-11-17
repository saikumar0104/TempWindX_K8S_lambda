locals {
  name = var.project_name
}

module "vpc" {
  source          = "./modules/vpc"
  name            = local.name
  cidr            = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  create_nat      = var.create_nat_gateway
}

module "rds" {
  source                 = "./modules/rds"
  name                   = "${local.name}-rds"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = var.db_allocated_storage
  instance_class         = var.db_instance_class
  subnet_ids             = module.vpc.public_subnet_ids
  publicly_accessible    = var.enable_public_rds
  vpc_security_group_ids = [module.vpc.default_security_group_id]
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "${local.name}-eks"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  node_instance_type = var.node_instance_type
  desired_capacity   = var.node_desired_capacity
  region             = var.region
}


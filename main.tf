module "vpc" {
  source = "./modules/vpc"

  availability_zones    = var.availability_zones
  cidr_block            = var.cidr_block
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}


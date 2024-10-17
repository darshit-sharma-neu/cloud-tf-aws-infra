module "vpc" {
  source = "./modules/vpc"

  availability_zones    = var.availability_zones
  cidr_block            = var.cidr_block
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs

  vpc_tag_name                            = var.vpc_tag_name
  public_subnet_tag_name                  = var.public_subnet_tag_name
  private_subnet_tag_name                 = var.private_subnet_tag_name
  igw_tag_name                            = var.igw_tag_name
  public_route_table_tag_name             = var.public_route_table_tag_name
  private_route_table_tag_name            = var.private_route_table_tag_name
  public_route_table_association_tag_name = var.public_route_table_association_tag_name

}

module "ec2" {
  source = "./modules/ec2"

  ami                 = var.ami
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_ids[0]
  vpc_id              = module.vpc.vpc_id
  app_port            = var.app_port
  security_group_name = var.security_group_name
  instance_name       = var.instance_name
}


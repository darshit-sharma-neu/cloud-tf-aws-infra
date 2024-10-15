module "vpcc" {
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


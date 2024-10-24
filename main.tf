# Create VPC
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

# Create rds security group
module "rds_security_group" {
  source = "./modules/security_groups"

  vpc_id              = module.vpc.vpc_id
  security_group_name = var.db_security_group_name
  description         = var.db_security_group_description
  ingress_rules = [
    {
      description     = "Allow Mysql traffic from app security group"
      from_port       = var.db_port
      to_port         = var.db_port
      protocol        = "tcp"
      security_groups = [module.app_security_group.security_group_id]
    }
  ]
  egress_rules = []
  tags = {
    Name = var.db_security_group_name
  }
}

# Create ec2 security group
module "app_security_group" {
  source = "./modules/security_groups"

  vpc_id              = module.vpc.vpc_id
  security_group_name = var.app_security_group_name
  description         = var.app_security_group_description
  ingress_rules = [
    {
      description = "Allow SSH from anywhere"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    , {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    , {
      description = "Allow HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    , {
      description = "Allow Application traffic from anywhere"
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      description = "Allow all traffic to anywhere"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = var.app_security_group_name
  }
}

# Create RDS Instance
module "db_instance" {
  source = "./modules/rds"
  # Engine details
  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version

  # DB details
  db_username = var.db_username
  db_name     = var.db_name
  db_password = var.db_password
  db_port     = var.db_port

  # Security group
  db_vpc_security_group_ids = [module.rds_security_group.security_group_id]

  # Instance details
  db_identifier          = var.db_identifier
  db_publicly_accessible = var.db_publicly_accessible
  db_skip_final_snapshot = var.db_skip_final_snapshot
  db_subnet_group_name   = module.vpc.private_subnet_ids[0]
  db_deletion_protection = var.db_deletion_protection
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_multi_az            = var.db_multi_az
  db_subnet_ids          = module.vpc.private_subnet_ids

  # Parameter group
  db_param_group_name        = var.db_param_group_name
  db_param_group_family      = var.db_param_group_family
  db_param_group_description = var.db_param_group_description



}


# Create EC2 Instace
module "ec2" {
  source     = "./modules/ec2"
  depends_on = [module.db_instance]

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_id                      = module.vpc.vpc_id
  app_port                    = var.app_port
  security_group_ids          = [module.app_security_group.security_group_id]
  instance_name               = var.instance_name
  volume_size                 = var.volume_size
  associate_public_ip_address = var.associate_public_ip_address
  delete_on_termination       = var.delete_on_termination
  disable_api_termination     = var.disable_api_termination
  volume_type                 = var.volume_type

  db_host     = module.db_instance.db_address
  db_port     = var.db_port
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
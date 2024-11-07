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

# Create loadbalancer security group
module "load_balancer_security_group" {
  source = "./modules/security_groups"

  vpc_id              = module.vpc.vpc_id
  security_group_name = var.load_balancer_security_group_name
  description         = var.load_balancer_security_group_description

  ingress_rules = [{
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [{
    description = "Allow all traffic to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  tags = {
    Name = var.load_balancer_security_group_name
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
      description     = "Allow Application traffic load balancer security group"
      from_port       = var.app_port
      to_port         = var.app_port
      protocol        = "tcp"
      security_groups = [module.load_balancer_security_group.security_group_id]
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


# Create S3 bucket
module "s3_bucket" {
  source = "./modules/s3"

  transition_rule_days          = var.transition_rule_days
  transition_rule_storage_class = var.transition_rule_storage_class
  sse_algorithm                 = var.sse_algorithm
  force_destroy                 = var.force_destroy
  transition_rule_status        = var.transition_rule_status
}

# Create IAM Role
module "iam_role" {
  source = "./modules/iam"

  s3_bucket_name                = module.s3_bucket.bucket_name
  role_name                     = var.role_name
  s3_policy_name                = var.s3_policy_name
  s3_policy_description         = var.s3_policy_description
  cloudwatch_policy_name        = var.cloudwatch_policy_name
  cloudwatch_policy_description = var.cloudwatch_policy_description
}

resource "aws_iam_instance_profile" "webapp_instance_profile" {
  name = "webapp_instance_profile"
  role = module.iam_role.role_name
}

# Create Launch Template
module "launch_template" {
  source = "./modules/launch_template"

  ami                         = var.ami
  instance_type               = var.instance_type
  launch_template_name        = var.launch_template_name
  launch_template_description = var.launch_template_description
  launch_template_key_name    = var.launch_template_key_name
  volume_type                 = var.volume_type
  volume_size                 = var.volume_size
  block_device_name           = var.block_device_name
  bucket_name                 = module.s3_bucket.bucket_name
  db_name                     = var.db_name
  db_host                     = module.db_instance.db_address
  db_port                     = var.db_port
  db_username                 = var.db_username
  db_password                 = var.db_password
  delete_on_termination       = var.delete_on_termination
  iam_instance_profile        = aws_iam_instance_profile.webapp_instance_profile.name
  disable_api_termination     = var.disable_api_termination
  associate_public_ip_address = var.associate_public_ip_address
  cloudwatch_logs_group_name  = var.cloudwatch_logs_group_name
  cloudwatch_metric_namespace = var.cloudwatch_metric_namespace
  security_group_ids          = [module.app_security_group.security_group_id]
}
# Create Load Balaner
module "load_balancer" {
  source = "./modules/load_balancer"

  load_balancer_name         = var.load_balancer_name
  load_balancer_type         = var.load_balancer_type
  target_group_name          = var.target_group_name
  target_group_port          = var.target_group_port
  security_groups            = [module.load_balancer_security_group.security_group_id]
  vpc_id                     = module.vpc.vpc_id
  subnet_identifiers         = module.vpc.public_subnet_ids
  target_group_protocol      = var.target_group_protocol
  enable_deletion_protection = var.enable_deletion_protection
  load_balancer_internal     = var.load_balancer_internal

  health_check_healthy_threshold            = var.health_check_healthy_threshold
  load_balancer_listner_default_action_type = var.load_balancer_listner_default_action_type
  health_check_path                         = var.health_check_path
  health_check_protocol                     = var.health_check_protocol
  load_balancer_listner_protocol            = var.load_balancer_listner_protocol
  load_balancer_listner_port                = var.load_balancer_listner_port
  health_check_timeout                      = var.health_check_timeout
  health_check_interval                     = var.health_check_interval
  health_check_unhealthy_threshold          = var.health_check_unhealthy_threshold
  health_check_port                         = var.health_check_port
}
# Create Auto Scaler
module "autoscaler" {
  source = "./modules/auto_sacler"

  depends_on         = [module.app_security_group]
  launch_template_id = module.launch_template.launch_template_id
  subnet_identifiers = module.vpc.public_subnet_ids
  target_group_arns  = [module.load_balancer.target_group_arn]
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  health_check_type  = var.health_check_type

  autosacler_name                               = var.autosacler_name
  autosacler_created_instance_name              = var.autosacler_created_instance_name
  autosacler_scale_up_scaling_adjustment        = var.autosacler_scale_up_scaling_adjustment
  autosacler_scale_down_scaling_adjustment      = var.autosacler_scale_down_scaling_adjustment
  autosacler_scale_up_scaling_adjustment_type   = var.autosacler_scale_up_scaling_adjustment_type
  autosacler_scale_down_scaling_adjustment_type = var.autosacler_scale_down_scaling_adjustment_type
  autosacler_scale_up_scaling_cooldown          = var.autosacler_scale_up_scaling_cooldown
  autosacler_scale_down_scaling_cooldown        = var.autosacler_scale_down_scaling_cooldown

  cpu_alarm_high_name                = var.cpu_alarm_high_name
  cpu_alarm_high_namespace           = var.cpu_alarm_high_namespace
  cpu_alarm_high_statistic           = var.cpu_alarm_high_statistic
  cpu_alarm_high_comparison_operator = var.cpu_alarm_high_comparison_operator
  cpu_alarm_high_threshold           = var.cpu_alarm_high_threshold
  cpu_alarm_high_period              = var.cpu_alarm_high_period
  cpu_alarm_high_evaluation_periods  = var.cpu_alarm_high_evaluation_periods

  cpu_alarm_low_name                = var.cpu_alarm_low_name
  cpu_alarm_low_namespace           = var.cpu_alarm_low_namespace
  cpu_alarm_low_statistic           = var.cpu_alarm_low_statistic
  cpu_alarm_low_comparison_operator = var.cpu_alarm_low_comparison_operator
  cpu_alarm_low_threshold           = var.cpu_alarm_low_threshold
  cpu_alarm_low_period              = var.cpu_alarm_low_period
  cpu_alarm_low_evaluation_periods  = var.cpu_alarm_low_evaluation_periods
}

# Create Route53 Record
resource "aws_route53_record" "ec2_mapping" {
  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = var.route53_record_type

  alias {
    name                   = module.load_balancer.dns_name
    zone_id                = module.load_balancer.zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

# Create EC2 Instace
# module "ec2" {
#   source     = "./modules/ec2"
#   depends_on = [module.db_instance, module.s3_bucket, module.iam_role]

#   ami                         = var.ami
#   instance_type               = var.instance_type
#   subnet_id                   = module.vpc.public_subnet_ids[0]
#   vpc_id                      = module.vpc.vpc_id
#   app_port                    = var.app_port
#   security_group_ids          = [module.app_security_group.security_group_id]
#   instance_name               = var.instance_name
#   volume_size                 = var.volume_size
#   associate_public_ip_address = var.associate_public_ip_address
#   delete_on_termination       = var.delete_on_termination
#   disable_api_termination     = var.disable_api_termination
#   volume_type                 = var.volume_type

#   db_host     = module.db_instance.db_address
#   db_port     = var.db_port
#   db_name     = var.db_name
#   db_username = var.db_username
#   db_password = var.db_password

#   bucket_name = module.s3_bucket.bucket_name

#   route53_zone_id     = var.route53_zone_id
#   route53_record_name = var.route53_record_name
#   route53_record_type = var.route53_record_type
#   route53_record_ttl  = var.route53_record_ttl

#   iam_instance_profile = aws_iam_instance_profile.webapp_instance_profile.name

#   cloudwatch_logs_group_name  = var.cloudwatch_logs_group_name
#   cloudwatch_metric_namespace = var.cloudwatch_metric_namespace
# }

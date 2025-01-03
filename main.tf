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
  nat_eip_tag_name                        = var.nat_eip_tag_name
  nat_gateway_tag_name                    = var.nat_gateway_tag_name
  enable_dns_hostnames                    = var.enable_dns_hostnames
  enable_dns_support                      = var.enable_dns_support

}
# Create Keys
module "keys" {
  source = "./modules/keys"

  current_acc_id         = var.account_number
  ec2_instance_role_name = module.iam_role.role_name
  lambda_role_arn        = module.lambda.lambda_role_arn
}

# Create DB Password
resource "random_password" "rds_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name       = var.rds_secret_name
  kms_key_id = module.keys.secrets_manager_key_arn
}


resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = random_password.rds_password.result
}
resource "aws_secretsmanager_secret" "sendgrid_api_key" {
  name       = var.sendgrid_secret_name
  kms_key_id = module.keys.secrets_manager_key_arn
}


resource "aws_secretsmanager_secret_version" "sendgrid_api_key_version" {
  secret_id     = aws_secretsmanager_secret.sendgrid_api_key.id
  secret_string = var.sendgrid_api_key
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
      cidr_blocks = [var.my_ip]
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
  db_password = random_password.rds_password.result
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

  # Key details
  kms_key_id = module.keys.rds_key_arn

}

# Create S3 bucket
module "s3_bucket" {
  source = "./modules/s3"

  transition_rule_days          = var.transition_rule_days
  transition_rule_storage_class = var.transition_rule_storage_class
  sse_algorithm                 = var.sse_algorithm
  force_destroy                 = var.force_destroy
  transition_rule_status        = var.transition_rule_status
  kms_key_arn                   = module.keys.s3_key_arn
}

# Create IAM Role
module "iam_role" {
  source = "./modules/iam"

  s3_bucket_name                    = module.s3_bucket.bucket_name
  role_name                         = var.role_name
  s3_policy_name                    = var.s3_policy_name
  s3_policy_description             = var.s3_policy_description
  cloudwatch_policy_name            = var.cloudwatch_policy_name
  cloudwatch_policy_description     = var.cloudwatch_policy_description
  account_number                    = var.account_number
  region                            = var.aws_region
  secret_manager_policy_description = var.secret_manager_policy_description
  secret_manager_policy_name        = var.secret_manager_policy_name
  secret_name                       = aws_secretsmanager_secret.rds_secret.arn
  kms_key_ids                       = [module.keys.secrets_manager_key_arn, module.keys.s3_key_arn, module.keys.rds_key_arn]
}

resource "aws_iam_instance_profile" "webapp_instance_profile" {
  name = "webapp_instance_profile"
  role = module.iam_role.role_name
}

# Create Lambda Function
module "lambda" {
  source = "./modules/lambda"

  email_from            = var.email_from
  base_url              = var.base_url
  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.private_subnet_ids
  sendgrid_secret_id    = aws_secretsmanager_secret.sendgrid_api_key.name
  mailer_sns_topic_name = var.mailer_sns_topic_name
  lambda_vpc_policy_arn = var.lambda_vpc_policy_arn
  account_number        = var.account_number

  lambda_function_name              = var.lambda_function_name
  handler                           = var.handler
  runtime                           = var.runtime
  memory                            = var.memory
  timeout                           = var.timeout
  kms_key_ids                       = [module.keys.secrets_manager_key_arn]
  secret_manager_policy_description = "Lambda function secret manager policy"
  secret_name                       = aws_secretsmanager_secret.sendgrid_api_key.name
  secret_manager_policy_name        = "lambda_secret_manager_policy"
  secret_arn                        = aws_secretsmanager_secret.sendgrid_api_key.arn
}

# Create Launch Template
module "launch_template" {
  source = "./modules/launch_template"

  update_default_version      = var.launch_template_update_default_version
  region                      = var.aws_region
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
  sns_topic_arn               = module.lambda.sns_topic_arn
  delete_on_termination       = var.delete_on_termination
  iam_instance_profile        = aws_iam_instance_profile.webapp_instance_profile.name
  disable_api_termination     = var.disable_api_termination
  associate_public_ip_address = var.associate_public_ip_address
  cloudwatch_logs_group_name  = var.cloudwatch_logs_group_name
  cloudwatch_metric_namespace = var.cloudwatch_metric_namespace
  security_group_ids          = [module.app_security_group.security_group_id]
  kms_key_arn                 = module.keys.webapp_key_arn
  db_secret_name              = aws_secretsmanager_secret.rds_secret.name
  ebs_encrypted               = var.ebs_encrypted

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
  load_balancer_target_type  = var.load_balancer_target_type
  ssl_certificate_arn        = var.ssl_certificate_arn

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
  cpu_alarm_high_name_metric         = var.cpu_alarm_high_name_metric
  cpu_alarm_high_comparison_operator = var.cpu_alarm_high_comparison_operator
  cpu_alarm_high_threshold           = var.cpu_alarm_high_threshold
  cpu_alarm_high_period              = var.cpu_alarm_high_period
  cpu_alarm_high_evaluation_periods  = var.cpu_alarm_high_evaluation_periods

  cpu_alarm_low_name                = var.cpu_alarm_low_name
  cpu_alarm_low_namespace           = var.cpu_alarm_low_namespace
  cpu_alarm_low_statistic           = var.cpu_alarm_low_statistic
  cpu_alarm_low_name_metric         = var.cpu_alarm_low_name_metric
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

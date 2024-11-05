# VPC Variables
variable "availability_zones" {
  type = list(string)
}

variable "cidr_block" {
  type = string
}

variable "public_subnets_cidrs" {
  type = list(string)
}

variable "private_subnets_cidrs" {
  type = list(string)
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_tag_name" {
  type = string
}

variable "public_subnet_tag_name" {
  type = string
}

variable "private_subnet_tag_name" {
  type = string
}

variable "igw_tag_name" {
  type = string
}

variable "public_route_table_tag_name" {
  type = string
}

variable "public_route_table_association_tag_name" {
  type = string
}

variable "private_route_table_tag_name" {
  type = string
}

# EC2 Variables
variable "app_security_group_name" {
  type = string
}

variable "app_security_group_description" {
  type = string
}
variable "app_port" {
  type = number
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "disable_api_termination" {
  type    = bool
  default = false
}

variable "delete_on_termination" {
  type    = bool
  default = false
}

variable "volume_size" {
  type = number
}

variable "volume_type" {
  type = string
}

variable "route53_zone_id" {
  type = string
}
variable "route53_record_name" {
  type = string
}
variable "route53_record_type" {
  type = string
}
variable "route53_record_ttl" {
  type = string
}

variable "cloudwatch_logs_group_name" {
  type = string
}
variable "cloudwatch_logs_rentention_period" {
  type = number
}

variable "cloudwatch_metric_namespace" {
  type = string
}

# RDS Variables
variable "db_security_group_name" {
  type = string
}
variable "db_security_group_description" {
  type = string
}
variable "db_port" {
  type = number
}
variable "db_instance_class" {
  type = string
}
variable "db_engine" {
  type = string
}
variable "db_engine_version" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_publicly_accessible" {
  type = bool
}
variable "db_skip_final_snapshot" {
  type = bool
}
variable "db_deletion_protection" {
  type = bool
}
variable "db_allocated_storage" {
  type = number
}
variable "db_multi_az" {
  type = bool
}
variable "db_subnet_group_name" {
  type = string
}
variable "db_param_group_name" {
  type = string
}
variable "db_param_group_family" {
  type = string
}
variable "db_param_group_description" {
  type = string
}

variable "db_identifier" {
  type = string
}

variable "transition_rule_days" {
  type = string
}
variable "transition_rule_storage_class" {
  type = string
}
variable "sse_algorithm" {
  type = string
}
variable "force_destroy" {
  type = string
}
variable "transition_rule_status" {
  type = string
}

variable "role_name" {
  type = string
}
variable "s3_policy_name" {
  type = string
}
variable "s3_policy_description" {
  type = string
}
variable "cloudwatch_policy_name" {
  type = string
}
variable "cloudwatch_policy_description" {
  type = string
}

variable "load_balancer_security_group_name" {
  type = string
}
variable "load_balancer_security_group_description" {
  type = string
}
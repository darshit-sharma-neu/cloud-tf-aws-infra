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

# Launch Template Variables
variable "launch_template_name" {
  type = string
}
variable "launch_template_description" {
  type = string
}
variable "launch_template_key_name" {
  type = string
}
variable "block_device_name" {
  type = string
}

# Load Balancer Variables
variable "load_balancer_name" {
  type = string
}
variable "load_balancer_type" {
  type = string
}
variable "target_group_name" {
  type = string
}
variable "target_group_port" {
  type = number
}
variable "target_group_protocol" {
  type = string
}
variable "enable_deletion_protection" {
  type = bool
}
variable "load_balancer_internal" {
  type = bool
}

variable "evaluate_target_health" {
  type = bool
}

variable "health_check_healthy_threshold" {
  type = number
}
variable "load_balancer_listner_default_action_type" {
  type = string
}
variable "health_check_path" {
  type = string
}
variable "health_check_protocol" {
  type = string
}
variable "load_balancer_listner_protocol" {
  type = string
}
variable "load_balancer_listner_port" {
  type = number
}
variable "health_check_timeout" {
  type = number
}
variable "health_check_interval" {
  type = number
}
variable "health_check_unhealthy_threshold" {
  type = number
}
variable "health_check_port" {
  type = string
}

# Auto Scaling Variables
variable "desired_capacity" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "health_check_type" {
  type = string
}

variable "autosacler_name" {
  type = string
}
variable "autosacler_created_instance_name" {
  type = string
}
variable "autosacler_scale_up_scaling_adjustment" {
  type = number
}
variable "autosacler_scale_down_scaling_adjustment" {
  type = number
}
variable "autosacler_scale_up_scaling_adjustment_type" {
  type = string
}
variable "autosacler_scale_down_scaling_adjustment_type" {
  type = string
}
variable "autosacler_scale_up_scaling_cooldown" {
  type = number
}
variable "autosacler_scale_down_scaling_cooldown" {
  type = number
}
variable "cpu_alarm_high_name" {
  type = string
}
variable "cpu_alarm_high_namespace" {
  type = string
}
variable "cpu_alarm_high_statistic" {
  type = string
}
variable "cpu_alarm_high_comparison_operator" {
  type = string
}
variable "cpu_alarm_high_threshold" {
  type = number
}
variable "cpu_alarm_high_period" {
  type = number
}
variable "cpu_alarm_high_evaluation_periods" {
  type = number
}
variable "cpu_alarm_low_name" {
  type = string
}
variable "cpu_alarm_low_namespace" {
  type = string
}
variable "cpu_alarm_low_statistic" {
  type = string
}
variable "cpu_alarm_low_comparison_operator" {
  type = string
}
variable "cpu_alarm_low_threshold" {
  type = number
}
variable "cpu_alarm_low_period" {
  type = number
}
variable "cpu_alarm_low_evaluation_periods" {
  type = number
}

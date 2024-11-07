variable "desired_capacity" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "launch_template_id" {
  type = string
}
variable "subnet_identifiers" {
  type = list(string)
}
variable "target_group_arns" {
  type = list(string)
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
variable "autosacler_scale_up_scaling_adjustment_type" {
  type = string
}
variable "autosacler_scale_up_scaling_cooldown" {
  type = number
}
variable "autosacler_scale_down_scaling_adjustment" {
  type = number
}
variable "autosacler_scale_down_scaling_adjustment_type" {
  type = string
}
variable "autosacler_scale_down_scaling_cooldown" {
  type = number
}
variable "cpu_alarm_high_name" {
  type = string
}
variable "cpu_alarm_high_comparison_operator" {
  type = string
}
variable "cpu_alarm_high_evaluation_periods" {
  type = number
}
variable "cpu_alarm_high_namespace" {
  type = string
}
variable "cpu_alarm_high_period" {
  type = number
}
variable "cpu_alarm_high_statistic" {
  type = string
}
variable "cpu_alarm_high_threshold" {
  type = number
}
variable "cpu_alarm_low_name" {
  type = string
}
variable "cpu_alarm_low_comparison_operator" {
  type = string
}
variable "cpu_alarm_low_evaluation_periods" {
  type = number
}
variable "cpu_alarm_low_namespace" {
  type = string
}
variable "cpu_alarm_low_period" {
  type = number
}
variable "cpu_alarm_low_statistic" {
  type = string
}
variable "cpu_alarm_low_threshold" {
  type = number
}
variable "cpu_alarm_high_name_metric" {
  type = string
}
variable "cpu_alarm_low_name_metric" {
  type = string
}
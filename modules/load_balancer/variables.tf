variable "load_balancer_name" {
  type = string
}
variable "load_balancer_internal" {
  type = string
}
variable "load_balancer_type" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "subnet_identifiers" {
  type = list(string)
}
variable "enable_deletion_protection" {
  type = string
}
variable "target_group_name" {
  type = string
}
variable "target_group_port" {
  type = string
}
variable "target_group_protocol" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "health_check_protocol" {
  type = string
}
variable "health_check_path" {
  type = string
}
variable "health_check_port" {
  type = string
}
variable "health_check_interval" {
  type = string
}
variable "health_check_timeout" {
  type = string
}
variable "health_check_healthy_threshold" {
  type = string
}
variable "health_check_unhealthy_threshold" {
  type = string
}
variable "load_balancer_listner_port" {
  type = string
}
variable "load_balancer_listner_protocol" {
  type = string
}
variable "load_balancer_listner_default_action_type" {
  type = string
}
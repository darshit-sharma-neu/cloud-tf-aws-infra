variable "db_param_group_name" {
  type = string
}
variable "db_param_group_family" {
  type = string
}
variable "db_param_group_description" {
  type = string
}
variable "db_subnet_ids" {
  type = list(string)
}
variable "db_identifier" {
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "db_multi_az" {
  type = bool
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
variable "db_vpc_security_group_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "db_port" {
  type = number
}
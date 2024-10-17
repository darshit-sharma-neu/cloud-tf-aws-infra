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
variable "security_group_name" {
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

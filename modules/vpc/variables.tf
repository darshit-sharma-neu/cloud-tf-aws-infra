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

variable "private_route_table_tag_name" {
  type = string
}
variable "public_route_table_association_tag_name" {
  type = string
}



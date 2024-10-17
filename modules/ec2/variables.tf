variable "security_group_name" {
  type = string
}

variable "vpc_id" {
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

variable "subnet_id" {
  type = string
}

variable "instance_name" {
  type = string

}

variable "security_group_description" {
  type    = string
  default = "Security group for webapp"
}
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

variable "sendgrid_secret_id" {
  type = string
}
variable "email_from" {
  type = string
}
variable "base_url" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "subnets" {
  type = list(string)
}

variable "mailer_sns_topic_name" {
  type = string
}

variable "security_group_name" {
  type    = string
  default = "csye6225-mailer-sg"
}
variable "security_group_description" {
  type    = string
  default = "Security group for csye6225-mailer"
}

variable "lambda_function_name" {
  type = string
}
variable "handler" {
  type = string
}
variable "runtime" {
  type = string
}
variable "timeout" {
  type = number
}
variable "memory" {
  type = number
}

variable "lambda_vpc_policy_arn" {
  type = string
}

variable "account_number" {
  type = string
}

variable "secret_manager_policy_name" {
  type = string
}
variable "secret_manager_policy_description" {
  type = string
}

variable "secret_name" {
  type = string
}

variable "secret_arn" {
  type = string
}
variable "kms_key_ids" {
  type = list(string)
}
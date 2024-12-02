variable "s3_bucket_name" {
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

variable "secret_manager_policy_name" {
  type = string
}
variable "secret_manager_policy_description" {
  type = string
}
variable "region" {
  type = string
}
variable "account_number" {
  type = string
}
variable "secret_name" {
  type = string
}

variable "kms_key_ids" {
  type = list(string)
}
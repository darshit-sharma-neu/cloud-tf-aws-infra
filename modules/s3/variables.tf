variable "force_destroy" {
  type = bool
}
variable "sse_algorithm" {
  type = string
}
variable "transition_rule_status" {
  type = string
}
variable "transition_rule_days" {
  type = number
}
variable "transition_rule_storage_class" {
  type = string
}

variable "kms_key_arn"{
  type = string
}
variable sendgrid_api_key{
    type = string
}
variable email_from{
    type = string
}
variable base_url{
    type = string
}

variable vpc_id{
    type = string
}
variable subnets{
    type = list(string)
}

variable "mailer_sns_topic_name" {
  type = string
}

variable security_group_name{
    type = string
    default = "csye6225-mailer-sg"
}
variable security_group_description{
    type = string
    default = "Security group for csye6225-mailer"
}

variable lambda_function_name{
    type = string
}
variable handler{
    type = string
}
variable runtime{
    type = string
}
variable timeout{
    type = number
}
variable memory{
    type = number
}
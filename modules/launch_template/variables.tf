variable ami{
    type = string
}
variable instance_type{
    type = string
}
variable disable_api_termination{
    type = string
}
variable security_group_names{
    type = list(string)
}
variable iam_instance_profile{
    type = string
}
variable associate_public_ip_address{
    type = string
}
variable volume_size{
    type = number
}
variable volume_type{
    type = string
}
variable delete_on_termination{
    type = bool
}
variable db_host{
    type = string
}
variable db_username{
    type = string
}
variable db_password{
    type = string
}
variable db_port{
    type = number
}
variable db_name{
    type = string
}
variable bucket_name{
    type = string
}
variable cloudwatch_logs_group_name {
    type = string
}
variable cloudwatch_metric_namespace  {
    type = string
}
variable launch_template_name{
    type = string
}
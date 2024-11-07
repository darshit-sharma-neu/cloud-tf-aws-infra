output "security_group_id" {
  value = aws_security_group.this_sec_group.id
}

output "security_group_name" {
  value = aws_security_group.this_sec_group.name
}
output "sns_topic_arn" {
  value = aws_sns_topic.mailer_sns_topic.arn
}

output "lambda_role_arn" {
  value = module.iam_lambda_role.role_arn
}
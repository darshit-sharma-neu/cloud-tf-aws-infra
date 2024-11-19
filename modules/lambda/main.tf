# Create SNS Topic
resource "aws_sns_topic" "mailer_sns_topic" {
  name = var.mailer_sns_topic_name
  policy = jsonencode({
     Version = "2012-10-17",
    Id      = "sns-topic-policy",
    Statement = [
      {
        Sid       = "AllowPublish",
        Effect    = "Allow",
        Principal = "*",
        Action    = "sns:Publish",
        Resource  = "arn:aws:sns:us-east-1:911167914313:csye6225-mailer-sns-topic"
      }
    ]
    }
  )
}

module "iam_lambda_role" {
  source    = "../iam/roles"
  role_name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

module "iam_lambda_policy" {
  source = "../iam/policies"

  policy_name        = "lambda_policy"
  policy_description = "Policy for lambda function"
  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "sns:Subscribe",
          "sns:Publish"
        ],
        Resource = "arn:aws:sns:us-east-1:911167914313:csye6225-mailer-sns-topic"
      }
    ]
  })
}

# Attach the Custom Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_custom_policy" {
  role       = module.iam_lambda_role.role_name
  policy_arn = module.iam_lambda_policy.policy_arn
}

# Attach AWS Managed Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_policy" {
  role       = module.iam_lambda_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

module "security_group" {
  source              = "../security_groups"
  security_group_name = var.security_group_name
  description         = var.security_group_description
  vpc_id              = var.vpc_id
  ingress_rules       = []
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_function_name
  role             = module.iam_lambda_role.role_arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory
  filename         = "${path.module}/lambda-package.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda-package.zip")
  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = [module.security_group.security_group_id]
  }

  environment {
    variables = {
      SENDGRID_API_KEY = var.sendgrid_api_key
      EMAIL_FROM       = var.email_from
      BASE_URL         = var.base_url
    }
  }
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.mailer_sns_topic.arn
}

resource "aws_sns_topic_subscription" "lambda_sns_trigger" {
  topic_arn = aws_sns_topic.mailer_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda.arn
}



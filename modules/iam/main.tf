module "iam_ec2_role" {
  source    = "../iam/roles"
  role_name = "ec2_role"
  assume_role_policy = jsonencode(file("${path.module}/ec2_role_policy.json"))
}

module "iam_s3_policy" {
  source = "../iam/policies"

  policy_name        = "s3_policy"
  policy_description = "Allow S3 access"
  policy_document    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",              
          "arn:aws:s3:::${var.s3_bucket_name}/*"             
        ]
      }
    ]
  })
}

module "iam_cloudwatch_policy" {
  source = "../iam/policies"

  policy_name        = "cloudwatch_policy"
  policy_description = "Allow CloudWatch access"
  policy_document    = jsonencode(file("${path.module}/cloudwatch_policy.json"))
  
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = module.iam_s3_policy.policy_arn
  role       = module.iam_ec2_role.role_name 
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = module.iam_s3_policy.policy_arn
  role       = module.iam_ec2_role.role_name 
}
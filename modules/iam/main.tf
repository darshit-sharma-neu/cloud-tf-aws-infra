module "iam_ec2_role" {
  source             = "../iam/roles"
  role_name          = var.role_name
  assume_role_policy = file("${path.module}/ec2_role_policy.json")
}

module "iam_s3_policy" {
  source = "../iam/policies"

  policy_name        = var.s3_policy_name
  policy_description = var.s3_policy_description
  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
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

  policy_name        = var.cloudwatch_policy_name
  policy_description = var.cloudwatch_policy_description
  policy_document    = file("${path.module}/cloudwatch_policy.json")

}

module "secret_manager_policy" {
  source = "../iam/policies"

  policy_name        = var.secret_manager_policy_name
  policy_description = var.secret_manager_policy_description
  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowSecretsManagerAccess",
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = "${var.secret_name}"
        }, {
        Sid    = "AllowKMSKeyAccess",
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource = var.kms_key_ids
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = module.iam_s3_policy.policy_arn
  role       = module.iam_ec2_role.role_name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  policy_arn = module.iam_cloudwatch_policy.policy_arn
  role       = module.iam_ec2_role.role_name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_attachment" {
  policy_arn = module.secret_manager_policy.policy_arn
  role       = module.iam_ec2_role.role_name
}

# EC2 instance key
resource "aws_kms_key" "webapp_instance_key" {
  description             = "KMS key for webapp instances"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
     {
      "Sid": "Allow EC2 Instance Role to Use KMS Key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:role/${var.ec2_instance_role_name}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
   "Sid": "Allow service-linked role use of the customer managed key",
   "Effect": "Allow",
   "Principal": {
       "AWS": [
           "arn:aws:iam::${var.current_acc_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
       ]
   },
   "Action": [
       "kms:Encrypt",
       "kms:Decrypt",
       "kms:ReEncrypt*",
       "kms:GenerateDataKey*",
       "kms:DescribeKey"
   ],
   "Resource": "*"
   },
   {
   "Sid": "Allow attachment of persistent resources",
   "Effect": "Allow",
   "Principal": {
       "AWS": [
           "arn:aws:iam::${var.current_acc_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
       ]
   },
   "Action": [
       "kms:CreateGrant"
   ],
   "Resource": "*",
   "Condition": {
       "Bool": {
           "kms:GrantIsForAWSResource": true
       }
    }
  }
  ]
}
EOT
}

resource "aws_kms_alias" "webapp_alias" {
  name          = "alias/webapp"
  target_key_id = aws_kms_key.webapp_instance_key.key_id
}

# RDS instance key
resource "aws_kms_key" "rds_key" {
  description             = "KMS key for rds instances"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow EC2 Instance Role to Use KMS Key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:role/${var.ec2_instance_role_name}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::${var.current_acc_id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
      },
      "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_kms_alias" "rds_alias" {
  name          = "alias/rds"
  target_key_id = aws_kms_key.rds_key.key_id
}

# S3 bucket key
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 instances"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
        "Sid": "Allow S3 Encryption",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::${var.current_acc_id}:role/${var.ec2_instance_role_name}"
        },
        "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
        ],
        "Resource": "*"
    },
    {
        "Sid": "Allow Grant Creation for S3 Resources",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::${var.current_acc_id}:role/${var.ec2_instance_role_name}"
        },
        "Action": [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
        ],
        "Resource": "*",
        "Condition": {
            "Bool": {
                "kms:GrantIsForAWSResource": "true"
            }
        }
    }
  ]
}
EOT
}

resource "aws_kms_alias" "s3_alias" {
  name          = "alias/s3"
  target_key_id = aws_kms_key.s3_key.key_id
}

# Secrets Manager key
resource "aws_kms_key" "secrets_manager_key" {
  description             = "KMS key for Secrets Manager"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow EC2 Instance Role to Use KMS Key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.current_acc_id}:role/${var.ec2_instance_role_name}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
        "Sid": "Allow use of the key for lambda role",
        "Effect": "Allow",
        "Principal": {
            "AWS": "${var.lambda_role_arn}"
        },
        "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
        ],
        "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_kms_alias" "secrets_manager_alias" {
  name          = "alias/secrets_manager"
  target_key_id = aws_kms_key.secrets_manager_key.key_id
}

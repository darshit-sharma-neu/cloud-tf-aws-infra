resource "random_uuid" "bucket_uuid" {}

resource "aws_s3_bucket" "this" {
  bucket        = random_uuid.bucket_uuid.result
  force_destroy = var.force_destroy

  tags = {
    Name = random_uuid.bucket_uuid.result
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    id     = "Transition rule to Standard IA"
    status = var.transition_rule_status

    transition {
      days          = var.transition_rule_days
      storage_class = var.transition_rule_storage_class
    }
  }
}
# ---------------- AWS Config Setup ----------------
resource "aws_config_configuration_recorder" "config" {
  name     = "default"
  role_arn = aws_iam_role.config_role.arn
  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_bucket.id
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.config.name
  is_enabled = true
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "aws-config-security-bucket-logs"
}

resource "aws_s3_bucket_public_access_block" "config_bucket" {
  bucket                  = aws_s3_bucket.config_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.config_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

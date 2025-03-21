# ---------------- AWS Managed Config Rules ----------------
resource "aws_config_config_rule" "all_rules" {
  count = length(var.managed_rules)
  name  = var.managed_rules[count.index]
  source {
    owner             = "AWS"
    source_identifier = var.managed_rules[count.index]
  }
}

variable "managed_rules" {
  type    = list(string)
  default = [
    "IAM_PASSWORD_POLICY",
    "S3_BUCKET_PUBLIC_READ_PROHIBITED",
    "RDS_STORAGE_ENCRYPTED",
    "EC2_SECURITY_GROUP_ATTACHED_TO_ENI",
    "EBS_OPTIMIZED_INSTANCE",
    "ECR_PRIVATE_IMAGE_SCANNING_ENABLED",
  ]
}
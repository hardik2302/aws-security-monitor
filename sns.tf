# ---------------- SNS for Email Notifications ----------------
resource "aws_sns_topic" "config_alerts" {
  name = "config-alerts"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.config_alerts.arn
  protocol  = "email"
  endpoint  = "hardikagrawal2320@gmail.com"  # Change to your email
}
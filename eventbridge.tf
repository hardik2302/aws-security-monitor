# ---------------- EventBridge Rule for Non-Compliance ----------------
resource "aws_cloudwatch_event_rule" "config_rule_violation" {
  name        = "aws-config-rule-violation"
  description = "Triggers when AWS Config detects a non-compliant resource"
  event_pattern = <<EOF
{
  "source": ["aws.config"],
  "detail-type": ["Config Rules Compliance Change"],
  "detail": {
    "newEvaluationResult": {
      "complianceType": ["NON_COMPLIANT"]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.config_rule_violation.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.config_alert.arn
}
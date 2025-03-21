# Lambda Function
resource "aws_lambda_function" "config_alert" {
  function_name    = "config-alert-lambda"
  image_uri     = "${aws_ecr_repository.ecr_repo.repository_url}:aws-config"
  package_type  = "Image"
  role            = aws_iam_role.lambda_role.arn
  skip_destroy = false //Set to true if you do not wish the function to be deleted at destroy time, and instead just remove the function from the Terraform state.
  timeout = 900
   environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.config_alerts.arn
    }
  }
}

resource "aws_lambda_permission" "eventbridge" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.config_alert.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.config_rule_violation.arn
}

# IAM For Config
resource "aws_iam_role" "config_role" {
  name = "AWSConfigRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "aws_config_policy" {
  name        = "AWSConfigCustomPolicy"
  description = "Custom policy for AWS Config"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "config:PutEvaluations",
          "config:DescribeConfigRules",
          "config:GetComplianceDetailsByConfigRule",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config_custom_policy_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.aws_config_policy.arn
}

resource "aws_iam_role_policy_attachment" "config_managed_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}


# IAM For Lambda

resource "aws_iam_role" "lambda_role" {
  name = "aws-config-alerts-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "aws-config-alerts-lambda-policy"
  description = "Policy for AWS Config Alerts Lambda"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "config:DescribeConfigRules",
          "config:DescribeComplianceByConfigRule",
          "config:GetComplianceDetailsByConfigRule",
          "config:GetComplianceDetailsByResource"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = aws_sns_topic.config_alerts.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_config_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

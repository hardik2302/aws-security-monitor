AWS Config Compliance Monitoring with Lambda & ECR

Overview

This project sets up AWS Config rules to monitor compliance across AWS resources. When a non-compliant resource is detected, a Lambda function is triggered to send an email notification. The Lambda function is deployed as a Docker container hosted in Amazon Elastic Container Registry (ECR).

Architecture

AWS Config Rules: Tracks compliance status of AWS resources.

Amazon EventBridge: Triggers the Lambda function on non-compliance.

AWS Lambda (Docker): Processes non-compliant events and sends email alerts.

Amazon ECR: Stores the Dockerized Lambda function.

Amazon SNS: Sends email notifications.

Prerequisites

AWS CLI installed and configured

Terraform installed

Docker installed

Setup Instructions

1. Clone the Repository

git clone https://github.com/hardik2302/aws-security-monitor.git
cd aws-lambda-docker

2. Deploy with Terraform

terraform init
terraform apply -auto-approve

3. Test the Setup

Trigger a non-compliant AWS Config rule by creating a misconfigured resource.

Check the AWS Lambda logs in CloudWatch.

Verify email alerts are received via Amazon SNS.

Cleanup

To delete all resources:

terraform destroy -auto-approve

Notes

The Lambda function reads non-compliant AWS Config events and sends an email via Amazon SNS.

The IAM role for Lambda has permissions for AWS Config, SNS, and logging.

Next Steps

Extend AWS Config rules to cover additional services.

Integrate with other alerting mechanisms like Slack.

Author: Hardik AgrawalLast Updated: March 2025


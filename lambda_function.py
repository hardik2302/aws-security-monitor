import json
import boto3
import os

sns_client = boto3.client("sns")

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")

def lambda_handler(event, context):
    try:
        detail = event.get("detail", {})
        
        # Extract rule name, resource, and compliance type
        rule_name = detail.get("configRuleName", "Unknown Rule")
        resource_id = detail.get("resourceId", "Unknown Resource")
        compliance_type = detail.get("complianceType", "Unknown Status")

        # Format the alert message
        message = (
            f"🚨 **AWS Config Compliance Alert** 🚨\n\n"
            f"🔹 **Rule Violated:** {rule_name}\n"
            f"🔹 **Non-Compliant Resource:** {resource_id}\n"
            f"🔹 **Compliance Status:** {compliance_type}\n\n"
            f"🔍 Please check AWS Config for more details."
        )

        # Send the email alert via SNS
        response = sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f"AWS Config Alert: {rule_name} Failed",
            Message=message
        )

        print("Alert sent:", response)
        return {"statusCode": 200, "body": "Notification sent"}

    except Exception as e:
        print("Error:", str(e))
        return {"statusCode": 500, "body": "Error sending notification"}

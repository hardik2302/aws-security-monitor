# Use the official AWS Lambda Python 3.9 image as the base image
FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.9

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the handler function
COPY lambda_function.py ${LAMBDA_TASK_ROOT}

# Command to run the Lambda function
CMD ["lambda_function.lambda_handler"]

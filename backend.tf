terraform {
  backend "s3" {
    bucket = "backendterraform-state"
    key    = "aws-security"
    region = "ap-south-1"
  }
}
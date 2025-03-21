resource "aws_ecr_repository" "ecr_repo" {
  name = "aws-security"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
  EOF
}

# Pushing the Image

resource "null_resource" "build_and_push_image" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr_repo.repository_url}
      docker build -t ${aws_ecr_repository.ecr_repo.repository_url}:aws-config .
      docker push ${aws_ecr_repository.ecr_repo.repository_url}:aws-config
    EOT

    environment = {
      AWS_PROFILE = "default"
    }
  }
}
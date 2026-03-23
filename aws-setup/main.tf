provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "app_role" {
  name = "payment-api-vault-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "app_policy" {
  name   = "s3-access"
  role   = aws_iam_role.app_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

output "role_arn" {
  value = aws_iam_role.app_role.arn
}

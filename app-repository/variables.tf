variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "application_iam_role_arn" {
  description = "The pre-existing AWS IAM Role ARN that the Vault Secret Engine will assume."
  type        = string
}

variable "tfc_project_name" {
  description = "The name of the Terraform Cloud project hosting this application."
  type        = string
  default     = "landing-zone-test"
}

variable "vault_aws_access_key" {
  description = "AWS Root Identity Key"
  type        = string
  sensitive   = true
}

variable "vault_aws_secret_key" {
  description = "AWS Root Identity Secret"
  type        = string
  sensitive   = true
}

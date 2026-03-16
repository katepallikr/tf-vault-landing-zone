variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "application_iam_role_arn" {
  description = "IAM Role ARN for the Vault AWS secrets engine to assume."
  type        = string
}

variable "tfc_project_name" {
  description = "TFC project name."
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

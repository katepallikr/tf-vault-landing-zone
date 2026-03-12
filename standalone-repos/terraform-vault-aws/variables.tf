# Vault AWS Secrets Engine Submodule — Variables

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

variable "vault_namespace" {
  description = "The target Vault namespace where the AWS secrets engine will be mounted (e.g., 'admin/my-app')."
  type        = string
}

variable "application_name" {
  description = "The name of the application. Used as a prefix for policies and mount paths."
  type        = string
}

variable "mount_path" {
  description = "The path where the AWS secrets engine will be mounted. Defaults to 'aws'."
  type        = string
  default     = "aws"
}

variable "vault_aws_access_key" {
  description = "The AWS access key ID for Vault to use as its root credentials. If omitted, Vault will attempt to use its own EC2/EKS instance profile."
  type        = string
  default     = null
  sensitive   = true
}

variable "vault_aws_secret_key" {
  description = "The AWS secret access key for Vault to use as its root credentials."
  type        = string
  default     = null
  sensitive   = true
}

variable "region" {
  description = "The default AWS region for STS tokens (e.g., 'us-east-1')."
  type        = string
  default     = "us-east-1"
}

variable "roles" {
  description = "A map of Vault roles to create. The key is the Vault role name, and the value is the AWS IAM role ARN to assume."
  type = map(object({
    iam_role_arn    = string
    credential_type = optional(string, "assumed_role")
    default_sts_ttl = optional(number, 3600)
    max_sts_ttl     = optional(number, 14400)
  }))
}

variable "tfc_workspace_vault_roles" {
  description = "A list of TFC Vault Roles that need permission to request these AWS credentials. This auto-generates a Vault policy."
  type        = list(string)
  default     = []
}



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
  description = "Target Vault namespace (e.g., 'admin/my-app')."
  type        = string
}

variable "application_name" {
  description = "App name prefix."
  type        = string
}

variable "mount_path" {
  description = "AWS engine mount path."
  type        = string
  default     = "aws"
}

variable "vault_aws_access_key" {
  description = "AWS access key for Vault root creds. Null = use instance profile."
  type        = string
  default     = null
  sensitive   = true
}

variable "vault_aws_secret_key" {
  description = "AWS secret key."
  type        = string
  default     = null
  sensitive   = true
}

variable "region" {
  description = "Default AWS region."
  type        = string
  default     = "us-east-1"
}

variable "roles" {
  description = "Map of Vault roles to AWS IAM Role ARNs."
  type = map(object({
    iam_role_arn    = string
    credential_type = optional(string, "assumed_role")
    default_sts_ttl = optional(number, 3600)
    max_sts_ttl     = optional(number, 14400)
  }))
}

variable "tfc_workspace_vault_roles" {
  description = "TFC Vault Roles needing access to these credentials."
  type        = list(string)
  default     = []
}

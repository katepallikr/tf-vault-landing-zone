variable "organization_name" {
  description = "Terraform organization name."
  type        = string
}

variable "platform_type" {
  description = "Platform variant: hcp or enterprise."
  type        = string
  default     = "hcp"
}

variable "tfe_hostname" {
  description = "TFE hostname (enterprise only)."
  type        = string
  default     = "app.terraform.io"
}

variable "vault_url" {
  description = "Vault cluster URL."
  type        = string
}

variable "vault_namespace" {
  description = "Parent Vault namespace."
  type        = string
  default     = "admin"
}

variable "oauth_token_id" {
  description = "OAuth token ID for VCS connectivity."
  type        = string
  default     = ""
}

variable "create_jwt_backend" {
  description = "Whether to create the JWT auth backend."
  type        = bool
  default     = true
}

variable "enable_sentinel" {
  description = "Whether to enable Sentinel policies."
  type        = bool
  default     = false
}

variable "sentinel_policy_set_ids" {
  description = "Sentinel policy set IDs."
  type        = list(string)
  default     = []
}

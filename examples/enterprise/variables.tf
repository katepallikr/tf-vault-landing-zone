variable "organization_name" {
  description = "TFE organization name."
  type        = string
}

variable "tfe_hostname" {
  description = "Terraform Enterprise hostname."
  type        = string
  default     = "tfe.corp.internal"
}

variable "vault_url" {
  description = "Vault Enterprise URL."
  type        = string
}

variable "vault_namespace" {
  description = "Root Vault namespace."
  type        = string
  default     = ""
}

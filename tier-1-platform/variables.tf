variable "organization_name" {
  description = "TFC/TFE organization name."
  type        = string
}

variable "project_name" {
  description = "Project name to be created by the platform tier."
  type        = string
}

variable "tfe_hostname" {
  description = "TFE hostname (if using Enterprise)."
  type        = string
  default     = "app.terraform.io"
}

variable "enable_vault_integration" {
  description = "Enable and provision the global Vault JWT Auth Backend."
  type        = bool
  default     = true
}

variable "vault_url" {
  description = "Vault cluster URL."
  type        = string
  default     = ""
}

variable "vault_namespace" {
  description = "Vault parent namespace."
  type        = string
  default     = ""
}

variable "vault_jwt_auth_path" {
  description = "Path to mount the JWT auth backend."
  type        = string
  default     = "jwt"
}

variable "vault_audience" {
  description = "Audience claim for workload identities."
  type        = string
  default     = "vault.workload.identity"
}

variable "variable_set_ids" {
  description = "Global Variable Set IDs to attach to the project."
  type        = list(string)
  default     = []
}

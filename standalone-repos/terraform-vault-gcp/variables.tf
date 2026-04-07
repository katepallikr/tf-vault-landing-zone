variable "vault_namespace" {
  description = "The Vault namespace to mount the GCP backend in."
  type        = string
  default     = ""
}

variable "application_name" {
  description = "The name of the application. Used for tagging and descriptions."
  type        = string
}

variable "mount_path" {
  description = "The path to mount the GCP secrets engine."
  type        = string
  default     = "gcp"
}

variable "credentials" {
  description = "The GCP Service Account JSON credentials for Vault to authenticate."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "The default GCP Project ID."
  type        = string
}

variable "rolesets" {
  description = "Map of GCP rolesets to create inside the Vault Secrets backend."
  type = map(object({
    secret_type  = string # "access_token" or "service_account_key"
    token_scopes = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    bindings = list(object({
      resource = string
      roles    = list(string)
    }))
  }))
  default = {}
}

variable "tfc_workspace_vault_roles" {
  description = "A list of existing Vault OIDC Roles (e.g. from TFC workspaces) that should be granted read access to the GCP generated credentials."
  type        = list(string)
  default     = []
}

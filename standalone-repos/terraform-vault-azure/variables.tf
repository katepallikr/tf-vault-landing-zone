variable "vault_namespace" {
  description = "The Vault namespace to mount the Azure backend in."
  type        = string
  default     = ""
}

variable "application_name" {
  description = "The name of the application. Used for tagging and descriptions."
  type        = string
}

variable "mount_path" {
  description = "The path to mount the Azure secrets engine."
  type        = string
  default     = "azure"
}

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID."
  type        = string
}

variable "client_id" {
  description = "The Application client ID for Vault to authenticate to Azure."
  type        = string
}

variable "client_secret" {
  description = "The secret for Vault to authenticate to Azure."
  type        = string
  sensitive   = true
}

variable "roles" {
  description = "Map of Azure roles to create inside the Vault Secrets backend."
  type = map(object({
    default_ttl = optional(number, 3600)
    max_ttl     = optional(number, 14400)
    azure_roles = list(object({
      role_name = string
      scope     = string
    }))
  }))
  default = {}
}

variable "tfc_workspace_vault_roles" {
  description = "A list of existing Vault OIDC Roles (e.g. from TFC workspaces) that should be granted read access to the Azure generated credentials."
  type        = list(string)
  default     = []
}

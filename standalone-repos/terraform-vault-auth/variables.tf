variable "organization_name" {
  description = "Terraform organization name for bound claims."
  type        = string
}

variable "project_name" {
  description = "Terraform project name for bound claims."
  type        = string
}

variable "application_name" {
  description = "Application identifier."
  type        = string
}

variable "tfc_hostname" {
  description = "Hostname of the Terraform platform (OIDC issuer)."
  type        = string
}

variable "vault_namespace" {
  description = "Vault namespace where the JWT backend and roles are created."
  type        = string
  default     = ""
}

variable "jwt_auth_path" {
  description = "Mount path for the JWT auth backend."
  type        = string
  default     = "jwt"
}

variable "create_jwt_backend" {
  description = "Whether to create the JWT auth backend. Set false if it already exists."
  type        = bool
  default     = true
}

variable "vault_audience" {
  description = "Expected audience in workload identity tokens."
  type        = string
  default     = "vault.workload.identity"
}

variable "vault_role_map" {
  description = "Map of environment to Vault role configuration."
  type = map(object({
    role_name         = string
    plan_role_name    = string
    bound_claim       = string
    plan_bound_claim  = string
    apply_bound_claim = string
  }))
}

variable "role_token_policies" {
  description = "List of Vault policy names to attach to roles."
  type        = list(string)
}

variable "token_ttl" {
  description = "Default TTL in seconds for issued tokens."
  type        = number
  default     = 1200
}

variable "token_max_ttl" {
  description = "Maximum TTL in seconds for issued tokens."
  type        = number
  default     = 2400
}

variable "enable_plan_apply_separation" {
  description = "Whether to create separate plan/apply roles."
  type        = bool
  default     = false
}

variable "custom_policy_hcl" {
  description = "Map of policy names to HCL content for custom policies."
  type        = map(string)
  default     = {}
}

variable "base_policy_name" {
  description = "Name for the base token self-management policy."
  type        = string
}

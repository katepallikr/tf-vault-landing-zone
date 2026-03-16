variable "organization_name" {
  description = "TFC/TFE org (used in bound claims)."
  type        = string
}

variable "project_name" {
  description = "Project name for bound claims."
  type        = string
}

variable "application_name" {
  description = "App identifier."
  type        = string
}

variable "tfc_hostname" {
  description = "TFC/TFE hostname (OIDC issuer)."
  type        = string
}

variable "vault_namespace" {
  description = "Target Vault namespace."
  type        = string
  default     = ""
}

variable "jwt_auth_path" {
  description = "JWT auth mount path."
  type        = string
  default     = "jwt"
}

variable "create_jwt_backend" {
  description = "Create the JWT backend, or false if it exists."
  type        = bool
  default     = true
}

variable "vault_audience" {
  description = "Expected audience claim."
  type        = string
  default     = "vault.workload.identity"
}

variable "vault_role_map" {
  description = "env => role config."
  type = map(object({
    role_name         = string
    plan_role_name    = string
    bound_claim       = string
    plan_bound_claim  = string
    apply_bound_claim = string
  }))
}

variable "role_token_policies" {
  description = "Policy names to attach to roles."
  type        = list(string)
}

variable "token_ttl" {
  description = "Token TTL (seconds)."
  type        = number
  default     = 1200
}

variable "token_max_ttl" {
  description = "Token max TTL (seconds)."
  type        = number
  default     = 2400
}

variable "enable_plan_apply_separation" {
  description = "Separate plan/apply roles."
  type        = bool
  default     = false
}

variable "custom_policy_hcl" {
  description = "policy name => HCL map."
  type        = map(string)
  default     = {}
}

variable "base_policy_name" {
  description = "Base self-manage policy name."
  type        = string
}

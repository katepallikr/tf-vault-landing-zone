variable "organization_name" {
  description = "TFC/TFE org name."
  type        = string
}

variable "project_name" {
  description = "TFC project."
  type        = string
}

variable "application_name" {
  description = "App name prefix."
  type        = string
}

variable "workspace_map" {
  description = "Environment => workspace map."
  type = map(object({
    workspace_name = string
    environment    = string
    working_dir    = string
  }))
}

variable "terraform_version" {
  description = "TF version."
  type        = string
  default     = ">= 1.6.0"
}

variable "auto_apply" {
  description = "Auto-apply plans."
  type        = bool
  default     = false
}

variable "vcs_repo" {
  description = "VCS repo."
  type = object({
    identifier     = string
    branch         = optional(string, "main")
    oauth_token_id = optional(string)
    tags_regex     = optional(string)
  })
  default = null
}

variable "workspace_tags" {
  description = "Workspace tags."
  type        = list(string)
  default     = []
}

variable "team_access" {
  description = "Team access map."
  type = map(object({
    access = string
  }))
  default = {}
}

variable "additional_variables" {
  description = "Extra variables."
  type = map(object({
    value     = string
    category  = optional(string, "env")
    sensitive = optional(bool, false)
  }))
  default = {}
}

variable "enable_vault_integration" {
  description = "Enable Vault dynamic credentials."
  type        = bool
  default     = false
}

variable "vault_url" {
  description = "Vault URL."
  type        = string
  default     = ""
}

variable "vault_namespace" {
  description = "Vault namespace."
  type        = string
  default     = ""
}

variable "vault_jwt_auth_path" {
  description = "JWT auth mount."
  type        = string
  default     = "jwt"
}

variable "vault_audience" {
  description = "Audience claim."
  type        = string
  default     = "vault.workload.identity"
}

variable "vault_role_map" {
  description = "Env => Role config."
  type = map(object({
    role_name         = string
    plan_role_name    = string
    bound_claim       = string
    plan_bound_claim  = string
    apply_bound_claim = string
  }))
  default = {}
}

variable "enable_plan_apply_separation" {
  description = "Separate plan/apply."
  type        = bool
  default     = false
}

variable "run_trigger_source_workspace_ids" {
  description = "Source workspace IDs for run triggers."
  type        = list(string)
  default     = []
}

variable "sentinel_policy_set_ids" {
  description = "Sentinel policy set IDs to attach to the project."
  type        = list(string)
  default     = []
}

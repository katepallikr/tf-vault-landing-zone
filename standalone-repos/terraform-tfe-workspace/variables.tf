variable "organization_name" {
  description = "Name of the Terraform organization."
  type        = string
}

variable "project_name" {
  description = "Name of the project to create."
  type        = string
}

variable "application_name" {
  description = "Short identifier for the application."
  type        = string
}

variable "workspace_map" {
  description = "Map of environment to workspace configuration."
  type = map(object({
    workspace_name = string
    environment    = string
    working_dir    = string
  }))
}

variable "terraform_version" {
  description = "Terraform version constraint for workspaces."
  type        = string
  default     = ">= 1.6.0"
}

variable "auto_apply" {
  description = "Whether to auto-apply successful plans."
  type        = bool
  default     = false
}

variable "vcs_repo" {
  description = "VCS repository configuration. Null for CLI-driven workspaces."
  type = object({
    identifier     = string
    branch         = optional(string, "main")
    oauth_token_id = optional(string)
    tags_regex     = optional(string)
  })
  default = null
}

variable "workspace_tags" {
  description = "Tags to apply to workspaces."
  type        = list(string)
  default     = []
}

variable "team_access" {
  description = "Map of team names to access levels."
  type = map(object({
    access = string
  }))
  default = {}
}

variable "additional_variables" {
  description = "Additional variables to set on all workspaces."
  type = map(object({
    value     = string
    category  = optional(string, "env")
    sensitive = optional(bool, false)
  }))
  default = {}
}

variable "enable_vault_integration" {
  description = "Whether to set Vault dynamic credential variables."
  type        = bool
  default     = false
}

variable "vault_url" {
  description = "Vault cluster URL."
  type        = string
  default     = ""
}

variable "vault_namespace" {
  description = "Vault namespace for workspace authentication."
  type        = string
  default     = ""
}

variable "vault_jwt_auth_path" {
  description = "Vault JWT auth mount path."
  type        = string
  default     = "jwt"
}

variable "vault_audience" {
  description = "Workload identity audience claim."
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
  default = {}
}

variable "enable_plan_apply_separation" {
  description = "Whether to use separate plan/apply Vault roles."
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

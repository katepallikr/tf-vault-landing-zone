# Input variables grouped by platform config, workspace settings, Vault, and Day 2 ops.

# Platform Configuration

variable "platform_type" {
  description = "Set to 'hcp' or 'enterprise' depending on your Terraform/Vault stack."
  type        = string
  default     = "hcp"

  validation {
    condition     = contains(["hcp", "enterprise"], var.platform_type)
    error_message = "platform_type must be 'hcp' or 'enterprise'."
  }
}

variable "tfe_hostname" {
  description = "TFE hostname. Only relevant when platform_type = 'enterprise'."
  type        = string
  default     = "app.terraform.io"
}

# --- Organization and Project ---

variable "organization_name" {
  description = "TFC/TFE organization name."
  type        = string

  validation {
    condition     = length(var.organization_name) >= 3
    error_message = "Organization name must be at least 3 characters."
  }
}

variable "project_name" {
  description = "Project name for the landing zone. Workspaces and variable sets are scoped here."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9 _-]{1,38}[a-zA-Z0-9]$", var.project_name))
    error_message = "Project name must be 3-40 characters, start and end alphanumeric, and contain only letters, numbers, spaces, hyphens, or underscores."
  }
}

# --- Application Configuration ---

variable "application_name" {
  description = "App identifier — used as prefix for workspace names, Vault paths, and policies."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,28}[a-z0-9]$", var.application_name))
    error_message = "Application name must be 3-30 lowercase alphanumeric characters or hyphens, starting with a letter."
  }
}

variable "environments" {
  description = "Environments to create. Each gets a workspace + Vault role."
  type        = list(string)
  default     = ["dev", "prod"]

  validation {
    condition = alltrue([
      for env in var.environments : contains(["dev", "staging", "test", "prod"], env)
    ])
    error_message = "Each environment must be one of: dev, staging, test, prod."
  }

  validation {
    condition     = length(var.environments) == length(distinct(var.environments))
    error_message = "Environment names must be unique."
  }
}

# --- Workspace Settings ---

variable "workspace_terraform_version" {
  description = "Terraform version constraint for workspaces."
  type        = string
  default     = ">= 1.6.0"
}

variable "workspace_auto_apply" {
  description = "Auto-apply successful plans."
  type        = bool
  default     = false
}

variable "workspace_vcs_repo" {
  description = "VCS repo config. null = CLI-driven workspaces."
  type = object({
    identifier     = string
    branch         = optional(string, "main")
    oauth_token_id = optional(string)
    tags_regex     = optional(string)
  })
  default = null
}

variable "workspace_working_directory_pattern" {
  description = "Working directory pattern; {environment} is replaced per workspace (e.g. 'envs/{environment}')."
  type        = string
  default     = ""
}

variable "workspace_tags" {
  description = "Tags for all workspaces."
  type        = list(string)
  default     = ["managed-by-landing-zone"]
}

variable "workspace_additional_variables" {
  description = "Extra env or terraform variables to inject into all workspaces."
  type = map(object({
    value     = string
    category  = optional(string, "env")
    sensitive = optional(bool, false)
  }))
  default = {}
}

# Team Access

variable "team_access" {
  description = "Team name → access level mapping for the project."
  type = map(object({
    access = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for team, config in var.team_access :
      contains(["read", "write", "maintain", "admin", "custom"], config.access)
    ])
    error_message = "Team access must be one of: read, write, maintain, admin, custom."
  }
}

# --- Vault Integration ---

variable "enable_vault_integration" {
  description = "Toggle Vault JWT auth, roles, policies, and dynamic creds on workspaces."
  type        = bool
  default     = true
}

variable "vault_url" {
  description = "Vault cluster URL (e.g. https://vault.example.com:8200)."
  type        = string
  default     = ""

  validation {
    condition     = var.vault_url == "" || can(regex("^https?://", var.vault_url))
    error_message = "Vault URL must start with http:// or https://, or be empty if Vault integration is disabled."
  }
}

variable "vault_namespace" {
  description = "Parent Vault namespace ('admin' for HCP Vault, or your root namespace for Enterprise)."
  type        = string
  default     = ""
}

variable "vault_jwt_auth_path" {
  description = "JWT auth mount path. Change if 'jwt' is already taken."
  type        = string
  default     = "jwt"
}

variable "create_vault_jwt_auth_backend" {
  description = "Create the JWT backend, or false if it already exists."
  type        = bool
  default     = true
}

variable "vault_token_ttl" {
  description = "Default TTL (seconds) for workspace Vault tokens. 1200 = 20min per HC recommendation."
  type        = number
  default     = 1200

  validation {
    condition     = var.vault_token_ttl >= 300 && var.vault_token_ttl <= 7200
    error_message = "Token TTL must be between 300 (5 minutes) and 7200 (2 hours)."
  }
}

variable "vault_token_max_ttl" {
  description = "Max TTL (seconds). Tokens can't renew past this."
  type        = number
  default     = 2400

  validation {
    condition     = var.vault_token_max_ttl >= 600 && var.vault_token_max_ttl <= 14400
    error_message = "Maximum token TTL must be between 600 (10 minutes) and 14400 (4 hours)."
  }
}

variable "vault_policies" {
  description = "Extra Vault policy names to attach to roles (base self-manage policy is always included)."
  type        = list(string)
  default     = []
}

variable "vault_custom_policy_hcl" {
  description = "Custom policies as name => HCL. Created and attached alongside vault_policies."
  type        = map(string)
  default     = {}
}

variable "enable_vault_namespace" {
  description = "Create a dedicated app namespace in Vault (Enterprise/HCP only)."
  type        = bool
  default     = false
}

variable "vault_namespace_path" {
  description = "Namespace path relative to vault_namespace. Defaults to application_name."
  type        = string
  default     = ""
}

variable "enable_kv_secrets_engine" {
  description = "Mount KV v2 in the app namespace."
  type        = bool
  default     = true
}

variable "kv_secrets_path" {
  description = "KV v2 mount path (relative to app namespace)."
  type        = string
  default     = "secret"
}

variable "vault_audience" {
  description = "Audience claim for workload identity tokens. Must match JWT role bound_audiences."
  type        = string
  default     = "vault.workload.identity"
}

variable "enable_plan_apply_separation" {
  description = "Separate Vault roles for plan (read-only) vs apply (write)."
  type        = bool
  default     = false
}

# Sentinel Policy Sets (Optional)

variable "enable_sentinel_policies" {
  description = "Attach Sentinel policy sets to the project. Needs TFC Standard+ or TFE Plus."
  type        = bool
  default     = false
}

variable "sentinel_policy_set_ids" {
  description = "Sentinel policy set IDs to attach."
  type        = list(string)
  default     = []
}

# Run Triggers

variable "run_trigger_source_workspace_ids" {
  description = "Workspace IDs whose successful runs trigger this app's workspaces."
  type        = list(string)
  default     = []
}

# Day 2 Admin Operations

variable "variable_set_ids" {
  description = "Variable Set IDs to attach to the project."
  type        = list(string)
  default     = []
}

variable "slack_webhook_url" {
  description = "Slack webhook for notifications. Empty = disabled."
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_cloud_oidc" {
  description = "Set up OIDC credentials for AWS/GCP/Azure."
  type        = bool
  default     = false
}

variable "cloud_provider" {
  description = "Target cloud: aws, gcp, or azure."
  type        = string
  default     = "aws"
}

variable "provider_role_arn" {
  description = "AWS Role ARN / GCP SA email / Azure Client ID for OIDC."
  type        = string
  default     = ""
}

variable "run_task_ids" {
  description = "Run Task IDs to attach (Checkov, Infracost, etc)."
  type        = list(string)
  default     = []
}

# Tags and Metadata

variable "tags" {
  description = "Extra tags for all taggable resources."
  type        = map(string)
  default     = {}
}

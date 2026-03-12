# Landing Zone Module — Input Variables
#
# Organized by concern: platform configuration, Terraform workspace settings,
# Vault integration, and tagging. Every variable includes a description,
# type constraint, and validation where applicable.

# ─────────────────────────────────────────────
# Platform Configuration
# ─────────────────────────────────────────────

variable "platform_type" {
  description = "Deployment target. Use 'hcp' for HCP Terraform and HCP Vault Dedicated, or 'enterprise' for self-hosted Terraform Enterprise and Vault Enterprise."
  type        = string
  default     = "hcp"

  validation {
    condition     = contains(["hcp", "enterprise"], var.platform_type)
    error_message = "platform_type must be 'hcp' or 'enterprise'."
  }
}

variable "tfe_hostname" {
  description = "Hostname of the Terraform Enterprise instance. Only used when platform_type is 'enterprise'. Ignored for HCP Terraform."
  type        = string
  default     = "app.terraform.io"
}

# ─────────────────────────────────────────────
# Organization and Project
# ─────────────────────────────────────────────

variable "organization_name" {
  description = "Name of the HCP Terraform or Terraform Enterprise organization."
  type        = string

  validation {
    condition     = length(var.organization_name) >= 3
    error_message = "Organization name must be at least 3 characters."
  }
}

variable "project_name" {
  description = "Name of the project to create for the application landing zone. All workspaces and variable sets are scoped to this project."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9 _-]{1,38}[a-zA-Z0-9]$", var.project_name))
    error_message = "Project name must be 3-40 characters, start and end alphanumeric, and contain only letters, numbers, spaces, hyphens, or underscores."
  }
}

# ─────────────────────────────────────────────
# Application Configuration
# ─────────────────────────────────────────────

variable "application_name" {
  description = "Short identifier for the application being onboarded. Used as a prefix in workspace names, Vault paths, and policy names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,28}[a-z0-9]$", var.application_name))
    error_message = "Application name must be 3-30 lowercase alphanumeric characters or hyphens, starting with a letter."
  }
}

variable "environments" {
  description = "List of environments to provision. Each environment gets its own workspace and Vault role. Valid values are 'dev', 'staging', 'test', and 'prod'."
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

# ─────────────────────────────────────────────
# Workspace Settings
# ─────────────────────────────────────────────

variable "workspace_terraform_version" {
  description = "Terraform version constraint for provisioned workspaces. Uses the latest compatible version."
  type        = string
  default     = ">= 1.6.0"
}

variable "workspace_auto_apply" {
  description = "Whether to automatically apply successful plans on the default branch."
  type        = bool
  default     = false
}

variable "workspace_vcs_repo" {
  description = "VCS repository configuration for application workspaces. Set to null for CLI-driven workspaces."
  type = object({
    identifier     = string
    branch         = optional(string, "main")
    oauth_token_id = optional(string)
    tags_regex     = optional(string)
  })
  default = null
}

variable "workspace_working_directory_pattern" {
  description = "Pattern for workspace working directories. Use '{environment}' as a placeholder. Example: 'envs/{environment}' results in 'envs/dev', 'envs/prod'."
  type        = string
  default     = ""
}

variable "workspace_tags" {
  description = "Tags to apply to every workspace created by this module."
  type        = list(string)
  default     = ["managed-by-landing-zone"]
}

variable "workspace_additional_variables" {
  description = "Additional environment or Terraform variables to set on all workspaces. Use the category field to specify 'env' or 'terraform'."
  type = map(object({
    value     = string
    category  = optional(string, "env")
    sensitive = optional(bool, false)
  }))
  default = {}
}

# ─────────────────────────────────────────────
# Team Access
# ─────────────────────────────────────────────

variable "team_access" {
  description = "Map of team names to their project-level access. Permissions follow HCP Terraform's built-in roles."
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

# ─────────────────────────────────────────────
# Vault Integration
# ─────────────────────────────────────────────

variable "enable_vault_integration" {
  description = "Whether to configure Vault resources including the JWT auth backend, roles, policies, and dynamic provider credentials on workspaces."
  type        = bool
  default     = true
}

variable "vault_url" {
  description = "Full URL of the Vault cluster, including the protocol. Example: https://vault.example.com:8200"
  type        = string
  default     = ""

  validation {
    condition     = var.vault_url == "" || can(regex("^https?://", var.vault_url))
    error_message = "Vault URL must start with http:// or https://, or be empty if Vault integration is disabled."
  }
}

variable "vault_namespace" {
  description = "Parent Vault namespace. For HCP Vault Dedicated this is typically 'admin'. For Vault Enterprise, set to the root namespace or leave empty."
  type        = string
  default     = ""
}

variable "vault_jwt_auth_path" {
  description = "Mount path for the JWT auth method in Vault. Change this only if the default 'jwt' path is already in use."
  type        = string
  default     = "jwt"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_/-]*$", var.vault_jwt_auth_path))
    error_message = "JWT auth path must start with an alphanumeric character and contain only letters, numbers, underscores, hyphens, or slashes."
  }
}

variable "create_vault_jwt_auth_backend" {
  description = "Whether to create the JWT auth backend in Vault. Set to false if the backend already exists and you only need to add roles."
  type        = bool
  default     = true
}

variable "vault_token_ttl" {
  description = "Default TTL in seconds for Vault tokens issued to workspaces. HashiCorp recommends 1200 (20 minutes) for dynamic credentials."
  type        = number
  default     = 1200

  validation {
    condition     = var.vault_token_ttl >= 300 && var.vault_token_ttl <= 7200
    error_message = "Token TTL must be between 300 (5 minutes) and 7200 (2 hours)."
  }
}

variable "vault_token_max_ttl" {
  description = "Maximum TTL in seconds for Vault tokens. Tokens cannot be renewed beyond this duration."
  type        = number
  default     = 2400

  validation {
    condition     = var.vault_token_max_ttl >= 600 && var.vault_token_max_ttl <= 14400
    error_message = "Maximum token TTL must be between 600 (10 minutes) and 14400 (4 hours)."
  }
}

variable "vault_policies" {
  description = "List of additional Vault policy names to attach to workspace roles. The module always includes a base 'tfc-token-self-manage' policy."
  type        = list(string)
  default     = []
}

variable "vault_custom_policy_hcl" {
  description = "Map of custom Vault policy names to their HCL content. These policies are created and attached to workspace roles alongside any policies listed in vault_policies."
  type        = map(string)
  default     = {}
}

variable "enable_vault_namespace" {
  description = "Whether to create a dedicated Vault namespace for this application. Requires Vault Enterprise or HCP Vault."
  type        = bool
  default     = false
}

variable "vault_namespace_path" {
  description = "Path for the application's Vault namespace, relative to vault_namespace. Defaults to the application_name if not set."
  type        = string
  default     = ""
}

variable "enable_kv_secrets_engine" {
  description = "Whether to mount a KV v2 secrets engine in the application namespace."
  type        = bool
  default     = true
}

variable "kv_secrets_path" {
  description = "Mount path for the KV v2 secrets engine. Relative to the application namespace."
  type        = string
  default     = "secret"
}

variable "vault_audience" {
  description = "The audience value for workload identity tokens. This must match the bound_audiences on the JWT auth role."
  type        = string
  default     = "vault.workload.identity"
}

variable "enable_plan_apply_separation" {
  description = "Whether to create separate Vault roles for plan and apply phases. When enabled, plan gets read-only access and apply gets write access."
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────
# Sentinel Policy Sets (Optional)
# ─────────────────────────────────────────────

variable "enable_sentinel_policies" {
  description = "Whether to attach Sentinel policy sets to the project. Requires HCP Terraform Standard or Terraform Enterprise Plus."
  type        = bool
  default     = false
}

variable "sentinel_policy_set_ids" {
  description = "List of existing Sentinel policy set IDs to attach to the project."
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────
# Run Triggers
# ─────────────────────────────────────────────

variable "run_trigger_source_workspace_ids" {
  description = "List of workspace IDs that should trigger runs in this application's workspaces when they complete successfully."
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────
# Day 2 Admin Operations
# ─────────────────────────────────────────────

variable "variable_set_ids" {
  description = "List of Variable Set IDs to attach to the project."
  type        = list(string)
  default     = []
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for workspace notifications. Leave empty to disable."
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_cloud_oidc" {
  description = "Whether to configure OIDC for AWS, GCP, or Azure on workspaces."
  type        = bool
  default     = false
}

variable "cloud_provider" {
  description = "The target cloud provider: 'aws', 'gcp', or 'azure'."
  type        = string
  default     = "aws"
}

variable "provider_role_arn" {
  description = "The ARN of the AWS role, GCP Service Account email, or Azure Client ID to assume via OIDC."
  type        = string
  default     = ""
}

variable "run_task_ids" {
  description = "List of TFE Run Task IDs (e.g., Checkov, Infracost) to attach to workloads."
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────
# Tags and Metadata
# ─────────────────────────────────────────────

variable "tags" {
  description = "Additional tags to apply to all resources that support tagging."
  type        = map(string)
  default     = {}
}

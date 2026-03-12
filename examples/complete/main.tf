# Complete Landing Zone Example
#
# Demonstrates every feature of the landing zone module:
# - Multiple environments with VCS-connected workspaces
# - Dedicated Vault namespace with KV secrets engine
# - Plan/apply role separation for least-privilege access
# - Team access controls
# - Custom Vault policies
# - Sentinel policy attachment

provider "tfe" {}

provider "vault" {}

module "payments_landing_zone" {
  source = "../../"

  # Platform — works with both HCP and Enterprise
  platform_type     = var.platform_type
  tfe_hostname      = var.tfe_hostname
  organization_name = var.organization_name
  project_name      = "payments-platform"

  # Application
  application_name = "payments-api"
  environments     = ["dev", "staging", "prod"]

  # Workspace settings
  workspace_auto_apply                = false
  workspace_terraform_version         = ">= 1.7.0"
  workspace_tags                      = ["payments", "pci-scope", "managed-by-landing-zone"]
  workspace_working_directory_pattern = "infrastructure/{environment}"

  workspace_vcs_repo = {
    identifier     = "acme-corp/payments-infrastructure"
    branch         = "main"
    oauth_token_id = var.oauth_token_id
  }

  workspace_additional_variables = {
    AWS_DEFAULT_REGION = {
      value    = "us-east-1"
      category = "env"
    }
  }

  # Team access
  team_access = {
    "payments-developers" = { access = "write" }
    "platform-engineers"  = { access = "admin" }
    "security-reviewers"  = { access = "read" }
  }

  # Vault integration
  enable_vault_integration      = true
  vault_url                     = var.vault_url
  vault_namespace               = var.vault_namespace
  vault_jwt_auth_path           = "jwt"
  create_vault_jwt_auth_backend = var.create_jwt_backend
  vault_token_ttl               = 1200
  vault_token_max_ttl           = 2400

  # Dedicated namespace with secrets engine
  enable_vault_namespace   = true
  enable_kv_secrets_engine = true
  kv_secrets_path          = "secret"

  # Least-privilege: separate read-only plan roles
  enable_plan_apply_separation = true

  # Custom policies for payment-specific secrets
  vault_custom_policy_hcl = {
    "payments-api-kv-reader" = file("${path.module}/policies/kv-reader.hcl")
    "payments-api-kv-writer" = file("${path.module}/policies/kv-writer.hcl")
  }

  # Sentinel (requires Standard+ tier)
  enable_sentinel_policies = var.enable_sentinel
  sentinel_policy_set_ids  = var.sentinel_policy_set_ids

  # Tags
  tags = {
    team        = "payments"
    cost-center = "CC-1234"
    compliance  = "pci-dss"
  }
}

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.50.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.23.0"
    }
  }
}

# 1. Core Project Setup
module "core_project" {
  source = "../standalone-repos/terraform-tfe-workspace"

  organization_name = var.organization_name
  project_name      = var.project_name
  create_project    = true

  # Tier 1 only sets up the project structure. No app workspaces.
  application_name = "core"
  workspace_map    = {}
}

# 2. Variable Sets
module "variable_sets" {
  source = "../standalone-repos/terraform-tfc-variable-sets"
  count  = length(var.variable_set_ids) > 0 ? 1 : 0

  project_id       = module.core_project.project_id
  variable_set_ids = var.variable_set_ids
}

# 3. Vault OIDC Backend Initialization
module "vault_auth_backend" {
  source = "../standalone-repos/terraform-vault-auth"
  count  = var.enable_vault_integration ? 1 : 0

  organization_name = var.organization_name
  project_name      = var.project_name
  application_name  = "core"

  tfc_hostname       = var.tfe_hostname
  vault_namespace    = var.vault_namespace
  jwt_auth_path      = var.vault_jwt_auth_path
  create_jwt_backend = true
  vault_audience     = var.vault_audience

  # No roles created in Tier 1.
  vault_role_map      = {}
  base_policy_name    = "core-tfc-base"
  role_token_policies = ["core-tfc-base"]
}

# Root orchestrator — wires up child modules for TFC workspace provisioning,
# Vault auth config, and optional Day 2 ops (notifications, run tasks, etc).
# Keep raw resources out of here; everything should be a module call.

# --- TFC Project and Workspaces ---

data "tfe_organization" "this" {
  name = var.organization_name

  lifecycle {
    postcondition {
      condition     = self.name == var.organization_name
      error_message = "The specified TFE organization '${var.organization_name}' was not found or the token lacks permission to view it."
    }
  }
}

module "workspace" {
  source = "./standalone-repos/terraform-tfe-workspace"

  organization_name    = var.organization_name
  project_name         = var.project_name
  application_name     = var.application_name
  workspace_map        = local.workspace_map
  terraform_version    = var.workspace_terraform_version
  auto_apply           = var.workspace_auto_apply
  vcs_repo             = var.workspace_vcs_repo
  workspace_tags       = var.workspace_tags
  team_access          = var.team_access
  additional_variables = var.workspace_additional_variables

  # Vault connectivity — only injected when Vault integration is active
  enable_vault_integration     = var.enable_vault_integration
  vault_url                    = var.vault_url
  vault_namespace              = local.vault_auth_namespace
  vault_jwt_auth_path          = var.vault_jwt_auth_path
  vault_audience               = var.vault_audience
  vault_role_map               = local.vault_role_map
  enable_plan_apply_separation = var.enable_plan_apply_separation

  run_trigger_source_workspace_ids = var.run_trigger_source_workspace_ids
  sentinel_policy_set_ids          = var.enable_sentinel_policies ? var.sentinel_policy_set_ids : []
}

# --- Vault JWT Auth Backend and Roles ---

module "vault_auth" {
  source = "./standalone-repos/terraform-vault-auth"
  count  = var.enable_vault_integration ? 1 : 0

  organization_name = var.organization_name
  project_name      = var.project_name
  application_name  = var.application_name

  tfc_hostname       = local.tfc_hostname
  vault_namespace    = local.vault_auth_namespace
  jwt_auth_path      = var.vault_jwt_auth_path
  create_jwt_backend = var.create_vault_jwt_auth_backend
  vault_audience     = var.vault_audience

  vault_role_map               = local.vault_role_map
  role_token_policies          = local.vault_role_policies
  token_ttl                    = var.vault_token_ttl
  token_max_ttl                = var.vault_token_max_ttl
  enable_plan_apply_separation = var.enable_plan_apply_separation

  custom_policy_hcl = var.vault_custom_policy_hcl
  base_policy_name  = local.vault_base_policy_name
}

# --- Vault Namespace and Secrets Engine (Optional) ---

module "vault_namespace" {
  source = "./standalone-repos/terraform-vault-namespace"
  count  = var.enable_vault_namespace ? 1 : 0

  namespace_path   = local.vault_app_namespace_path
  parent_namespace = local.vault_root_namespace
  enable_kv_engine = var.enable_kv_secrets_engine
  kv_mount_path    = var.kv_secrets_path
  application_name = var.application_name
  tags             = var.tags
}

# --- Day 2 Admin Operations (Optional) ---

module "variable_sets" {
  source = "./standalone-repos/terraform-tfc-variable-sets"
  count  = length(var.variable_set_ids) > 0 ? 1 : 0

  project_id       = module.workspace.project_id
  variable_set_ids = var.variable_set_ids
}

module "notifications" {
  source = "./standalone-repos/terraform-tfc-notifications"
  count  = var.slack_webhook_url != "" ? 1 : 0

  workspace_ids     = module.workspace.workspace_ids
  slack_webhook_url = var.slack_webhook_url
}

module "cloud_oidc" {
  source = "./standalone-repos/terraform-tfc-cloud-oidc"
  count  = var.enable_cloud_oidc ? 1 : 0

  workspace_ids     = module.workspace.workspace_ids
  cloud_provider    = var.cloud_provider
  provider_role_arn = var.provider_role_arn
}

module "run_tasks" {
  source   = "./standalone-repos/terraform-tfc-run-tasks"
  for_each = toset(var.run_task_ids)

  workspace_ids = module.workspace.workspace_ids
  run_task_id   = each.value
}


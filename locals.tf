# Landing Zone Module — Computed Values and Platform Resolution
#
# Centralizes all platform-specific logic so that resource definitions
# in main.tf remain clean and declarative.

locals {
  # Platform detection
  is_hcp        = var.platform_type == "hcp"
  is_enterprise = var.platform_type == "enterprise"

  # Terraform hostname resolution
  tfc_hostname = local.is_hcp ? "app.terraform.io" : var.tfe_hostname

  # OIDC discovery endpoint — Vault uses this to verify workspace JWTs
  oidc_discovery_url = "https://${local.tfc_hostname}"

  # Vault namespace resolution
  # HCP Vault Dedicated tokens implicitly operate under the 'admin' namespace.
  # Passing "admin" to resources causes relative 'admin/admin' errors.
  # Leaving it blank allows the provider to reliably use its 'admin' default.
  vault_root_namespace     = local.is_hcp ? "" : var.vault_namespace
  vault_app_namespace_path = var.vault_namespace_path != "" ? var.vault_namespace_path : var.application_name

  vault_full_namespace = (
    local.vault_root_namespace != ""
    ? "${local.vault_root_namespace}/${local.vault_app_namespace_path}"
    : local.vault_app_namespace_path
  )

  # The namespace where the JWT auth backend is mounted and roles are created.
  # When enable_vault_namespace is true, auth goes in the app namespace.
  # Otherwise, it stays in the parent namespace.
  vault_auth_namespace = var.enable_vault_namespace ? local.vault_full_namespace : local.vault_root_namespace

  # Workspace naming convention: <app>-<env>
  workspace_map = {
    for env in var.environments : env => {
      workspace_name = "${var.application_name}-${env}"
      environment    = env
      working_dir = (
        var.workspace_working_directory_pattern != ""
        ? replace(var.workspace_working_directory_pattern, "{environment}", env)
        : ""
      )
    }
  }

  # Vault role naming convention
  vault_role_map = {
    for env in var.environments : env => {
      role_name      = "${var.application_name}-tfc-${env}"
      plan_role_name = "${var.application_name}-tfc-${env}-plan"
      bound_claim = join(":", [
        "organization:${var.organization_name}",
        "project:${var.project_name}",
        "workspace:${var.application_name}-${env}",
        "run_phase:*"
      ])
      plan_bound_claim = join(":", [
        "organization:${var.organization_name}",
        "project:${var.project_name}",
        "workspace:${var.application_name}-${env}",
        "run_phase:plan"
      ])
      apply_bound_claim = join(":", [
        "organization:${var.organization_name}",
        "project:${var.project_name}",
        "workspace:${var.application_name}-${env}",
        "run_phase:apply"
      ])
    }
  }

  # Merge all policy names: base + custom + user-provided
  vault_base_policy_name    = "${var.application_name}-tfc-base"
  vault_all_custom_policies = keys(var.vault_custom_policy_hcl)
  vault_role_policies = concat(
    [local.vault_base_policy_name],
    var.vault_policies,
    local.vault_all_custom_policies
  )
}

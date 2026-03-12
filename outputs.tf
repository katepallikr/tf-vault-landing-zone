# Landing Zone Module — Outputs
#
# Exposes the identifiers and metadata that downstream consumers need
# to connect their infrastructure code to provisioned workspaces and Vault.

# ─────────────────────────────────────────────
# Project Outputs
# ─────────────────────────────────────────────

output "project_id" {
  description = "ID of the Terraform project created for this application."
  value       = module.workspace.project_id
}

output "project_name" {
  description = "Name of the Terraform project."
  value       = module.workspace.project_name
}

# ─────────────────────────────────────────────
# Workspace Outputs
# ─────────────────────────────────────────────

output "workspace_ids" {
  description = "Map of environment names to workspace IDs."
  value       = module.workspace.workspace_ids
}

output "workspace_names" {
  description = "Map of environment names to workspace names."
  value       = module.workspace.workspace_names
}

# ─────────────────────────────────────────────
# Vault Outputs
# ─────────────────────────────────────────────

output "vault_jwt_auth_path" {
  description = "Mount path of the JWT auth backend in Vault."
  value       = var.enable_vault_integration ? var.vault_jwt_auth_path : null
}

output "vault_role_names" {
  description = "Map of environment names to their Vault JWT auth role names."
  value = var.enable_vault_integration ? {
    for env, cfg in local.vault_role_map : env => cfg.role_name
  } : {}
}

output "vault_namespace" {
  description = "Full Vault namespace path where auth and secrets are configured."
  value       = var.enable_vault_integration ? local.vault_auth_namespace : null
}

output "vault_app_namespace" {
  description = "Vault namespace created for the application, if enabled."
  value       = var.enable_vault_namespace ? local.vault_full_namespace : null
}

output "vault_policy_names" {
  description = "List of all Vault policy names attached to workspace roles."
  value       = var.enable_vault_integration ? local.vault_role_policies : []
}

output "vault_token_ttl" {
  description = "Default TTL in seconds for Vault tokens issued to workspaces."
  value       = var.enable_vault_integration ? var.vault_token_ttl : null
}

output "vault_token_max_ttl" {
  description = "Maximum TTL in seconds for Vault tokens."
  value       = var.enable_vault_integration ? var.vault_token_max_ttl : null
}

# ─────────────────────────────────────────────
# Platform Metadata
# ─────────────────────────────────────────────

output "platform_type" {
  description = "The platform variant this landing zone targets."
  value       = var.platform_type
}

output "tfc_hostname" {
  description = "Resolved Terraform platform hostname."
  value       = local.tfc_hostname
}

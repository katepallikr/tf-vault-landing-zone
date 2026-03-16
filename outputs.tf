# Outputs for downstream consumption.

# Project

output "project_id" {
  description = "Terraform project ID."
  value       = module.workspace.project_id
}

output "project_name" {
  description = "Name of the Terraform project."
  value       = module.workspace.project_name
}

# Workspaces

output "workspace_ids" {
  description = "environment => workspace ID map."
  value       = module.workspace.workspace_ids
}

output "workspace_names" {
  description = "Map of environment names to workspace names."
  value       = module.workspace.workspace_names
}

# Vault

output "vault_jwt_auth_path" {
  description = "Mount path of the JWT auth backend in Vault."
  value       = var.enable_vault_integration ? var.vault_jwt_auth_path : null
}

output "vault_role_names" {
  description = "environment => Vault role name map."
  value = var.enable_vault_integration ? {
    for env, cfg in local.vault_role_map : env => cfg.role_name
  } : {}
}

output "vault_namespace" {
  description = "Vault namespace for auth and secrets."
  value       = var.enable_vault_integration ? local.vault_auth_namespace : null
}

output "vault_app_namespace" {
  description = "App-specific Vault namespace (null if not enabled)."
  value       = var.enable_vault_namespace ? local.vault_full_namespace : null
}

output "vault_policy_names" {
  description = "All policy names attached to workspace roles."
  value       = var.enable_vault_integration ? local.vault_role_policies : []
}

output "vault_token_ttl" {
  description = "Token TTL (seconds)."
  value       = var.enable_vault_integration ? var.vault_token_ttl : null
}

output "vault_token_max_ttl" {
  description = "Token max TTL (seconds)."
  value       = var.enable_vault_integration ? var.vault_token_max_ttl : null
}

# Platform Metadata

output "platform_type" {
  description = "hcp or enterprise."
  value       = var.platform_type
}

output "tfc_hostname" {
  description = "Resolved TFC/TFE hostname."
  value       = local.tfc_hostname
}

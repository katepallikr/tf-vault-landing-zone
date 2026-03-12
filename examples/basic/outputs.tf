output "project_id" {
  description = "ID of the created project."
  value       = module.app_landing_zone.project_id
}

output "workspace_ids" {
  description = "Map of environment names to workspace IDs."
  value       = module.app_landing_zone.workspace_ids
}

output "vault_role_names" {
  description = "Map of environments to their Vault role names."
  value       = module.app_landing_zone.vault_role_names
}

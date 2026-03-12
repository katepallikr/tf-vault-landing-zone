output "jwt_auth_path" {
  description = "Path where the JWT auth backend is mounted."
  value       = local.jwt_backend_path
}

output "role_names" {
  description = "Map of environment names to their primary Vault role names."
  value       = { for env, cfg in var.vault_role_map : env => cfg.role_name }
}

output "base_policy_name" {
  description = "Name of the base token self-management policy."
  value       = vault_policy.tfc_base.name
}

output "custom_policy_names" {
  description = "Names of custom policies created by this module."
  value       = [for name, _ in vault_policy.custom : name]
}

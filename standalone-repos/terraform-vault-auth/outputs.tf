output "jwt_auth_path" {
  description = "JWT backend mount path."
  value       = local.jwt_backend_path
}

output "role_names" {
  description = "env => role name map."
  value       = { for env, cfg in var.vault_role_map : env => cfg.role_name }
}

output "base_policy_name" {
  description = "Base self-manage policy name."
  value       = vault_policy.tfc_base.name
}

output "custom_policy_names" {
  description = "Custom policy names."
  value       = [for name, _ in vault_policy.custom : name]
}

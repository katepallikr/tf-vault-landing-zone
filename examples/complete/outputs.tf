output "project_id" {
  value = module.payments_landing_zone.project_id
}

output "workspace_ids" {
  value = module.payments_landing_zone.workspace_ids
}

output "vault_namespace" {
  value = module.payments_landing_zone.vault_app_namespace
}

output "vault_roles" {
  value = module.payments_landing_zone.vault_role_names
}

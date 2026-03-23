

output "backend_path" {
  description = "AWS engine mount path."
  value       = vault_aws_secret_backend.aws.path
}

output "roles" {
  description = "Configured Vault AWS roles."
  value       = [for r in vault_aws_secret_backend_role.assumed_roles : r.name]
}

output "reader_policy_name" {
  description = "Auto-generated Vault reader policy name."
  value       = length(vault_policy.tfc_aws_secrets_reader) > 0 ? vault_policy.tfc_aws_secrets_reader[0].name : ""
}

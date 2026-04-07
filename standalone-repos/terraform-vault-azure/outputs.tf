output "backend_path" {
  description = "The path where the Azure secrets engine is mounted."
  value       = vault_azure_secret_backend.azure.path
}

output "reader_policy_name" {
  description = "The name of the Vault policy created for TFC workspaces to read credentials."
  value       = length(vault_policy.tfc_azure_secrets_reader) > 0 ? vault_policy.tfc_azure_secrets_reader[0].name : ""
}

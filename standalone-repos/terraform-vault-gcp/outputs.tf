output "backend_path" {
  description = "The path where the GCP secrets engine is mounted."
  value       = vault_gcp_secret_backend.gcp.path
}

output "reader_policy_name" {
  description = "The name of the Vault policy created for TFC workspaces to read GCP credentials."
  value       = length(vault_policy.tfc_gcp_secrets_reader) > 0 ? vault_policy.tfc_gcp_secrets_reader[0].name : ""
}

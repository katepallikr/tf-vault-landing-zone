# Vault AWS Secrets Engine Submodule — Outputs

output "backend_path" {
  description = "The path where the AWS secrets engine is mounted."
  value       = vault_aws_secret_backend.aws.path
}

output "roles" {
  description = "A list of the Vault roles configured to issue AWS credentials."
  value       = [for r in vault_aws_secret_backend_role.assumed_roles : r.name]
}

output "reader_policy_name" {
  description = "The name of the Vault policy auto-generated for Terraform Workspaces to read AWS credentials from this engine."
  value       = length(vault_policy.tfc_aws_secrets_reader) > 0 ? vault_policy.tfc_aws_secrets_reader[0].name : ""
}

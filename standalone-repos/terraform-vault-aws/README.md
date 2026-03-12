# Terraform Vault AWS Secrets Engine

This module serves as the primary Vault-AWS integration point for application developers. It is separated cleanly from the core workspace provisioner.

**Capabilities:**
1. Dynamically mounts the AWS secret backend `vault_aws_secret_backend` at a custom namespace path.
2. Automates the generation of `assumed_role` bindings to pre-existing AWS IAM Roles.
3. Automatically writes Vault Policies that allow a Terraform Workspace to ingest those generated credentials securely during execution phases.

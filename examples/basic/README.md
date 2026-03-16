# Basic Example

Minimum config: one project, two workspaces, Vault wired up.

## What Gets Created

- One HCP Terraform project
- Two workspaces (dev, prod)
- JWT auth backend in Vault (if not already present)
- One Vault role per workspace with bound claims
- Base token self-management policy

## Prerequisites

1. An HCP Terraform organization with an API token
2. An HCP Vault Dedicated cluster (or Vault Enterprise)
3. A Vault token with permission to manage auth backends and policies

## Usage

```bash
export TFE_TOKEN="your-tfe-org-token"
export VAULT_ADDR="https://vault.example.com:8200"
export VAULT_TOKEN="your-vault-token"
export VAULT_NAMESPACE="admin"

terraform init
terraform plan -var="organization_name=my-org" -var="vault_url=$VAULT_ADDR"
terraform apply -var="organization_name=my-org" -var="vault_url=$VAULT_ADDR"
```

## Next Steps

After applying, connect application workspaces to a VCS repository and
add your infrastructure code. The Vault provider will authenticate
automatically using the configured workload identity.

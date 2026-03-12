# Enterprise Landing Zone Example

Demonstrates the module configured for self-hosted Terraform Enterprise
and Vault Enterprise.

## Key Differences from HCP

- `platform_type = "enterprise"` resolves the OIDC discovery URL to
  your custom TFE hostname
- `vault_namespace` does not require the `admin` prefix — set it to
  your root namespace or leave empty for the true root
- `vault_jwt_auth_path` can be customized to avoid conflicts with
  existing auth backends

## Usage

```bash
export TFE_TOKEN="your-tfe-token"
export TFE_ADDRESS="https://tfe.corp.internal"
export VAULT_ADDR="https://vault.corp.internal:8200"
export VAULT_TOKEN="your-vault-token"

terraform init
terraform apply \
  -var="organization_name=my-enterprise-org" \
  -var="tfe_hostname=tfe.corp.internal" \
  -var="vault_url=$VAULT_ADDR"
```

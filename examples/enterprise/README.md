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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.58.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_erp_landing_zone"></a> [erp\_landing\_zone](#module\_erp\_landing\_zone) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | TFE organization name. | `string` | n/a | yes |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | Terraform Enterprise hostname. | `string` | `"tfe.corp.internal"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Root Vault namespace. | `string` | `""` | no |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault Enterprise URL. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

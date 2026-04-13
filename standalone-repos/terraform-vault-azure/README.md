# terraform-vault-azure

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [vault_azure_secret_backend.azure](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/azure_secret_backend) | resource |
| [vault_azure_secret_backend_role.app_roles](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/azure_secret_backend_role) | resource |
| [vault_policy.tfc_azure_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of the application. Used for tagging and descriptions. | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The Application client ID for Vault to authenticate to Azure. | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The secret for Vault to authenticate to Azure. | `string` | n/a | yes |
| <a name="input_mount_path"></a> [mount\_path](#input\_mount\_path) | The path to mount the Azure secrets engine. | `string` | `"azure"` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Map of Azure roles to create inside the Vault Secrets backend. | <pre>map(object({<br/>    default_ttl = optional(number, 3600)<br/>    max_ttl     = optional(number, 14400)<br/>    azure_roles = list(object({<br/>      role_name = string<br/>      scope     = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure tenant ID. | `string` | n/a | yes |
| <a name="input_tfc_workspace_vault_roles"></a> [tfc\_workspace\_vault\_roles](#input\_tfc\_workspace\_vault\_roles) | A list of existing Vault OIDC Roles (e.g. from TFC workspaces) that should be granted read access to the Azure generated credentials. | `list(string)` | `[]` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | The Vault namespace to mount the Azure backend in. | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_path"></a> [backend\_path](#output\_backend\_path) | The path where the Azure secrets engine is mounted. |
| <a name="output_reader_policy_name"></a> [reader\_policy\_name](#output\_reader\_policy\_name) | The name of the Vault policy created for TFC workspaces to read credentials. |
<!-- END_TF_DOCS -->

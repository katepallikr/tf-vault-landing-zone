# terraform-vault-gcp

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
| [vault_gcp_secret_backend.gcp](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_backend) | resource |
| [vault_gcp_secret_roleset.rolesets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_roleset) | resource |
| [vault_policy.tfc_gcp_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of the application. Used for tagging and descriptions. | `string` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | The GCP Service Account JSON credentials for Vault to authenticate. | `string` | n/a | yes |
| <a name="input_mount_path"></a> [mount\_path](#input\_mount\_path) | The path to mount the GCP secrets engine. | `string` | `"gcp"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The default GCP Project ID. | `string` | n/a | yes |
| <a name="input_rolesets"></a> [rolesets](#input\_rolesets) | Map of GCP rolesets to create inside the Vault Secrets backend. | <pre>map(object({<br/>    secret_type  = string # "access_token" or "service_account_key"<br/>    token_scopes = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])<br/>    bindings = list(object({<br/>      resource = string<br/>      roles    = list(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_tfc_workspace_vault_roles"></a> [tfc\_workspace\_vault\_roles](#input\_tfc\_workspace\_vault\_roles) | A list of existing Vault OIDC Roles (e.g. from TFC workspaces) that should be granted read access to the GCP generated credentials. | `list(string)` | `[]` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | The Vault namespace to mount the GCP backend in. | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_path"></a> [backend\_path](#output\_backend\_path) | The path where the GCP secrets engine is mounted. |
| <a name="output_reader_policy_name"></a> [reader\_policy\_name](#output\_reader\_policy\_name) | The name of the Vault policy created for TFC workspaces to read GCP credentials. |
<!-- END_TF_DOCS -->

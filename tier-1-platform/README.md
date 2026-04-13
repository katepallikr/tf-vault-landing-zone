# tier-1-platform

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.50.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.23.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_core_project"></a> [core\_project](#module\_core\_project) | ../standalone-repos/terraform-tfe-workspace | n/a |
| <a name="module_variable_sets"></a> [variable\_sets](#module\_variable\_sets) | ../standalone-repos/terraform-tfc-variable-sets | n/a |
| <a name="module_vault_auth_backend"></a> [vault\_auth\_backend](#module\_vault\_auth\_backend) | ../standalone-repos/terraform-vault-auth | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_vault_integration"></a> [enable\_vault\_integration](#input\_enable\_vault\_integration) | Enable and provision the global Vault JWT Auth Backend. | `bool` | `true` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | TFC/TFE organization name. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name to be created by the platform tier. | `string` | n/a | yes |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | TFE hostname (if using Enterprise). | `string` | `"app.terraform.io"` | no |
| <a name="input_variable_set_ids"></a> [variable\_set\_ids](#input\_variable\_set\_ids) | Global Variable Set IDs to attach to the project. | `list(string)` | `[]` | no |
| <a name="input_vault_audience"></a> [vault\_audience](#input\_vault\_audience) | Audience claim for workload identities. | `string` | `"vault.workload.identity"` | no |
| <a name="input_vault_jwt_auth_path"></a> [vault\_jwt\_auth\_path](#input\_vault\_jwt\_auth\_path) | Path to mount the JWT auth backend. | `string` | `"jwt"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Vault parent namespace. | `string` | `""` | no |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault cluster URL. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

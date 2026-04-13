# Complete Example

Full-featured onboarding with all module capabilities enabled: VCS-connected workspaces, plan/apply Vault role separation, custom secret path access, team access controls, namespace quotas, and metadata tagging.

## Usage

```bash
terraform init
terraform apply -var-file="terraform.tfvars"
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
| <a name="module_payments_landing_zone"></a> [payments\_landing\_zone](#module\_payments\_landing\_zone) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_create_jwt_backend"></a> [create\_jwt\_backend](#input\_create\_jwt\_backend) | Create JWT backend. | `bool` | `true` | no |
| <a name="input_enable_sentinel"></a> [enable\_sentinel](#input\_enable\_sentinel) | Enable Sentinel. | `bool` | `false` | no |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | OAuth token ID for VCS. | `string` | `""` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | TFC/TFE org. | `string` | n/a | yes |
| <a name="input_platform_type"></a> [platform\_type](#input\_platform\_type) | Platform variant: hcp or enterprise. | `string` | `"hcp"` | no |
| <a name="input_sentinel_policy_set_ids"></a> [sentinel\_policy\_set\_ids](#input\_sentinel\_policy\_set\_ids) | Sentinel policy set IDs. | `list(string)` | `[]` | no |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | TFE hostname (enterprise only). | `string` | `"app.terraform.io"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Parent Vault namespace. | `string` | `"admin"` | no |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault cluster URL. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_vault_namespace"></a> [vault\_namespace](#output\_vault\_namespace) | n/a |
| <a name="output_vault_roles"></a> [vault\_roles](#output\_vault\_roles) | n/a |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | n/a |
<!-- END_TF_DOCS -->

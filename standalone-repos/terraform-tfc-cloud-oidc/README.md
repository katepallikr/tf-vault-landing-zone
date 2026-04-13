# terraform-tfc-cloud-oidc

Injects `TFC_AWS_PROVIDER_AUTH` / `TFC_GCP_*` / `TFC_AZURE_*` env vars on workspaces for cloud OIDC.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.58.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.76.2 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [tfe_variable.oidc](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Target cloud: aws, gcp, azure. | `string` | n/a | yes |
| <a name="input_provider_role_arn"></a> [provider\_role\_arn](#input\_provider\_role\_arn) | Target role ARN/email/client ID. | `string` | n/a | yes |
| <a name="input_workspace_ids"></a> [workspace\_ids](#input\_workspace\_ids) | Workspace ID map. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

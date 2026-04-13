# terraform-vault-aws

Mounts the AWS secrets engine and creates STS assumed-role bindings. Also generates a Vault policy for TFC workspaces to read the creds.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0.0, < 6.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [vault_aws_secret_backend.aws](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/aws_secret_backend) | resource |
| [vault_aws_secret_backend_role.assumed_roles](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/aws_secret_backend_role) | resource |
| [vault_policy.tfc_aws_secrets_reader](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | App name prefix. | `string` | n/a | yes |
| <a name="input_mount_path"></a> [mount\_path](#input\_mount\_path) | AWS engine mount path. | `string` | `"aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | Default AWS region. | `string` | `"us-east-1"` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Map of Vault roles to AWS IAM Role ARNs. | <pre>map(object({<br/>    iam_role_arn    = string<br/>    credential_type = optional(string, "assumed_role")<br/>    default_sts_ttl = optional(number, 3600)<br/>    max_sts_ttl     = optional(number, 14400)<br/>  }))</pre> | n/a | yes |
| <a name="input_tfc_workspace_vault_roles"></a> [tfc\_workspace\_vault\_roles](#input\_tfc\_workspace\_vault\_roles) | TFC Vault Roles needing access to these credentials. | `list(string)` | `[]` | no |
| <a name="input_vault_aws_access_key"></a> [vault\_aws\_access\_key](#input\_vault\_aws\_access\_key) | AWS access key for Vault root creds. Null = use instance profile. | `string` | `null` | no |
| <a name="input_vault_aws_secret_key"></a> [vault\_aws\_secret\_key](#input\_vault\_aws\_secret\_key) | AWS secret key. | `string` | `null` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Target Vault namespace (e.g., 'admin/my-app'). | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_path"></a> [backend\_path](#output\_backend\_path) | AWS engine mount path. |
| <a name="output_reader_policy_name"></a> [reader\_policy\_name](#output\_reader\_policy\_name) | Auto-generated Vault reader policy name. |
| <a name="output_roles"></a> [roles](#output\_roles) | Configured Vault AWS roles. |
<!-- END_TF_DOCS -->

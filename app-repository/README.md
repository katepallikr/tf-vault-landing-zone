# app-repository

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0.0, < 6.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.8.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_vault_aws_auth"></a> [vault\_aws\_auth](#module\_vault\_aws\_auth) | ./modules/terraform-vault-aws | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_kms_key.app_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.app_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.app_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.app_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.app_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [vault_aws_access_credentials.creds](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/aws_access_credentials) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_iam_role_arn"></a> [application\_iam\_role\_arn](#input\_application\_iam\_role\_arn) | IAM Role ARN for the Vault AWS secrets engine to assume. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `"us-east-1"` | no |
| <a name="input_tfc_project_name"></a> [tfc\_project\_name](#input\_tfc\_project\_name) | TFC project name. | `string` | `"landing-zone-test"` | no |
| <a name="input_vault_aws_access_key"></a> [vault\_aws\_access\_key](#input\_vault\_aws\_access\_key) | AWS Root Identity Key | `string` | n/a | yes |
| <a name="input_vault_aws_secret_key"></a> [vault\_aws\_secret\_key](#input\_vault\_aws\_secret\_key) | AWS Root Identity Secret | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

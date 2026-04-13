# terraform-vault-namespace

Creates a child namespace and optional KV v2 mount. Requires Vault Enterprise or HCP Vault.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0.0, < 6.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [vault_aws_secret_backend.aws](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/aws_secret_backend) | resource |
| [vault_mount.kv](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_namespace.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | App name (for metadata). | `string` | n/a | yes |
| <a name="input_aws_mount_path"></a> [aws\_mount\_path](#input\_aws\_mount\_path) | AWS secrets engine mount path. | `string` | `"aws"` | no |
| <a name="input_enable_aws_engine"></a> [enable\_aws\_engine](#input\_enable\_aws\_engine) | Mount AWS secrets engine in the namespace. | `bool` | `false` | no |
| <a name="input_enable_kv_engine"></a> [enable\_kv\_engine](#input\_enable\_kv\_engine) | Mount KV v2 in the namespace. | `bool` | `true` | no |
| <a name="input_kv_mount_path"></a> [kv\_mount\_path](#input\_kv\_mount\_path) | KV v2 mount path. | `string` | `"secret"` | no |
| <a name="input_namespace_path"></a> [namespace\_path](#input\_namespace\_path) | Child namespace path. | `string` | n/a | yes |
| <a name="input_parent_namespace"></a> [parent\_namespace](#input\_parent\_namespace) | Parent namespace (empty = root). | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom metadata tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_kv_mount_path"></a> [kv\_mount\_path](#output\_kv\_mount\_path) | KV v2 path (null if not created). |
| <a name="output_namespace_path"></a> [namespace\_path](#output\_namespace\_path) | Namespace path. |
| <a name="output_namespace_path_fq"></a> [namespace\_path\_fq](#output\_namespace\_path\_fq) | Fully qualified path. |
<!-- END_TF_DOCS -->

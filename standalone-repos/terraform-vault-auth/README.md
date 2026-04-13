# Vault Auth Module

Sets up Vault to trust TFC/TFE JWTs. 

It bounds claims so that the `dev` workspace can only get `dev` credentials.

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
| [vault_jwt_auth_backend.tfc](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.apply](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.plan](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.workspace](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_policy.custom](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.tfc_base](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_auth_backend.existing](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/auth_backend) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | App identifier. | `string` | n/a | yes |
| <a name="input_base_policy_name"></a> [base\_policy\_name](#input\_base\_policy\_name) | Base self-manage policy name. | `string` | n/a | yes |
| <a name="input_create_jwt_backend"></a> [create\_jwt\_backend](#input\_create\_jwt\_backend) | Create the JWT backend, or false if it exists. | `bool` | `true` | no |
| <a name="input_custom_policy_hcl"></a> [custom\_policy\_hcl](#input\_custom\_policy\_hcl) | policy name => HCL map. | `map(string)` | `{}` | no |
| <a name="input_enable_plan_apply_separation"></a> [enable\_plan\_apply\_separation](#input\_enable\_plan\_apply\_separation) | Separate plan/apply roles. | `bool` | `false` | no |
| <a name="input_jwt_auth_path"></a> [jwt\_auth\_path](#input\_jwt\_auth\_path) | JWT auth mount path. | `string` | `"jwt"` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | TFC/TFE org (used in bound claims). | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name for bound claims. | `string` | n/a | yes |
| <a name="input_role_token_policies"></a> [role\_token\_policies](#input\_role\_token\_policies) | Policy names to attach to roles. | `list(string)` | n/a | yes |
| <a name="input_tfc_hostname"></a> [tfc\_hostname](#input\_tfc\_hostname) | TFC/TFE hostname (OIDC issuer). | `string` | n/a | yes |
| <a name="input_token_max_ttl"></a> [token\_max\_ttl](#input\_token\_max\_ttl) | Token max TTL (seconds). | `number` | `2400` | no |
| <a name="input_token_ttl"></a> [token\_ttl](#input\_token\_ttl) | Token TTL (seconds). | `number` | `1200` | no |
| <a name="input_vault_audience"></a> [vault\_audience](#input\_vault\_audience) | Expected audience claim. | `string` | `"vault.workload.identity"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Target Vault namespace. | `string` | `""` | no |
| <a name="input_vault_role_map"></a> [vault\_role\_map](#input\_vault\_role\_map) | env => role config. | <pre>map(object({<br/>    role_name         = string<br/>    plan_role_name    = string<br/>    bound_claim       = string<br/>    plan_bound_claim  = string<br/>    apply_bound_claim = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_base_policy_name"></a> [base\_policy\_name](#output\_base\_policy\_name) | Base self-manage policy name. |
| <a name="output_custom_policy_names"></a> [custom\_policy\_names](#output\_custom\_policy\_names) | Custom policy names. |
| <a name="output_jwt_auth_path"></a> [jwt\_auth\_path](#output\_jwt\_auth\_path) | JWT backend mount path. |
| <a name="output_role_names"></a> [role\_names](#output\_role\_names) | env => role name map. |
<!-- END_TF_DOCS -->

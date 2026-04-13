# Workspace Module

Provisions TFC/TFE Projects and Workspaces.

- Creates the project
- Creates workspaces (dev, prod, etc)
- Mounts Vault variables
- Sets auto-apply

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.58.0, < 1.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.76.1 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [tfe_project.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_project_policy_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project_policy_set) | resource |
| [tfe_run_trigger.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/run_trigger) | resource |
| [tfe_team_project_access.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team_project_access) | resource |
| [tfe_variable.additional](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_addr](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_apply_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_auth_path](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_apply_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_auth_type](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_mount_path](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_plan_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_run_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_namespace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_plan_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_run_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_project.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/project) | data source |
| [tfe_team.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_variables"></a> [additional\_variables](#input\_additional\_variables) | Extra variables. | <pre>map(object({<br/>    value     = string<br/>    category  = optional(string, "env")<br/>    sensitive = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | App name prefix. | `string` | n/a | yes |
| <a name="input_auto_apply"></a> [auto\_apply](#input\_auto\_apply) | Auto-apply plans. | `bool` | `false` | no |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Create the TFC project or look it up. | `bool` | `true` | no |
| <a name="input_enable_plan_apply_separation"></a> [enable\_plan\_apply\_separation](#input\_enable\_plan\_apply\_separation) | Separate plan/apply. | `bool` | `false` | no |
| <a name="input_enable_vault_backed_aws_auth"></a> [enable\_vault\_backed\_aws\_auth](#input\_enable\_vault\_backed\_aws\_auth) | Enable native AWS Dynamic Provider Credentials via Vault. | `bool` | `false` | no |
| <a name="input_enable_vault_integration"></a> [enable\_vault\_integration](#input\_enable\_vault\_integration) | Enable Vault dynamic credentials. | `bool` | `false` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | TFC/TFE org name. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | TFC project. | `string` | n/a | yes |
| <a name="input_run_trigger_source_workspace_ids"></a> [run\_trigger\_source\_workspace\_ids](#input\_run\_trigger\_source\_workspace\_ids) | Run trigger source IDs. | `list(string)` | `[]` | no |
| <a name="input_sentinel_policy_set_ids"></a> [sentinel\_policy\_set\_ids](#input\_sentinel\_policy\_set\_ids) | Sentinel policy set IDs. | `list(string)` | `[]` | no |
| <a name="input_team_access"></a> [team\_access](#input\_team\_access) | Team access map. | <pre>map(object({<br/>    access = string<br/>  }))</pre> | `{}` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | TF version. | `string` | `">= 1.6.0"` | no |
| <a name="input_vault_audience"></a> [vault\_audience](#input\_vault\_audience) | Audience claim. | `string` | `"vault.workload.identity"` | no |
| <a name="input_vault_aws_auth_mount"></a> [vault\_aws\_auth\_mount](#input\_vault\_aws\_auth\_mount) | Vault AWS secrets engine mount path. | `string` | `"aws"` | no |
| <a name="input_vault_backed_aws_auth_type"></a> [vault\_backed\_aws\_auth\_type](#input\_vault\_backed\_aws\_auth\_type) | The default credential type Vault vends for AWS (iam\_user, assumed\_role, federation\_token). | `string` | `"assumed_role"` | no |
| <a name="input_vault_backed_aws_auth_type_map"></a> [vault\_backed\_aws\_auth\_type\_map](#input\_vault\_backed\_aws\_auth\_type\_map) | Optional overrides for AWS auth type per environment key. | `map(string)` | `{}` | no |
| <a name="input_vault_jwt_auth_path"></a> [vault\_jwt\_auth\_path](#input\_vault\_jwt\_auth\_path) | JWT auth mount. | `string` | `"jwt"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Vault namespace. | `string` | `""` | no |
| <a name="input_vault_role_map"></a> [vault\_role\_map](#input\_vault\_role\_map) | Env => Role config. | <pre>map(object({<br/>    role_name         = string<br/>    plan_role_name    = string<br/>    bound_claim       = string<br/>    plan_bound_claim  = string<br/>    apply_bound_claim = string<br/>  }))</pre> | `{}` | no |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault URL. | `string` | `""` | no |
| <a name="input_vcs_repo"></a> [vcs\_repo](#input\_vcs\_repo) | VCS repo. | <pre>object({<br/>    identifier     = string<br/>    branch         = optional(string, "main")<br/>    oauth_token_id = optional(string)<br/>    tags_regex     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_workspace_map"></a> [workspace\_map](#input\_workspace\_map) | Environment => workspace map. | <pre>map(object({<br/>    workspace_name                 = string<br/>    environment                    = string<br/>    working_dir                    = string<br/>    auto_destroy_activity_duration = optional(string, "")<br/>  }))</pre> | n/a | yes |
| <a name="input_workspace_tags"></a> [workspace\_tags](#input\_workspace\_tags) | Workspace tags. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project ID. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name. |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | env => workspace ID. |
| <a name="output_workspace_names"></a> [workspace\_names](#output\_workspace\_names) | env => workspace name. |
<!-- END_TF_DOCS -->

# tier-2-app-onboarding

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
| <a name="module_vault_auth"></a> [vault\_auth](#module\_vault\_auth) | ../standalone-repos/terraform-vault-auth | n/a |
| <a name="module_vault_namespace"></a> [vault\_namespace](#module\_vault\_namespace) | ../standalone-repos/terraform-vault-namespace | n/a |
| <a name="module_workspace"></a> [workspace](#module\_workspace) | ../standalone-repos/terraform-tfe-workspace | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | App identifier — used as prefix for workspace names, Vault paths, and policies. | `string` | n/a | yes |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Target cloud: aws, gcp, or azure. | `string` | `"aws"` | no |
| <a name="input_create_vault_aws_engine"></a> [create\_vault\_aws\_engine](#input\_create\_vault\_aws\_engine) | Whether to provision the AWS secrets engine in the Vault namespace. Set to false if the engine is already present. | `bool` | `false` | no |
| <a name="input_create_vault_jwt_auth_backend"></a> [create\_vault\_jwt\_auth\_backend](#input\_create\_vault\_jwt\_auth\_backend) | Create the JWT backend, or false if it already exists. | `bool` | `true` | no |
| <a name="input_enable_cloud_oidc"></a> [enable\_cloud\_oidc](#input\_enable\_cloud\_oidc) | Set up OIDC credentials for AWS/GCP/Azure. | `bool` | `false` | no |
| <a name="input_enable_kv_secrets_engine"></a> [enable\_kv\_secrets\_engine](#input\_enable\_kv\_secrets\_engine) | Mount KV v2 in the app namespace. | `bool` | `true` | no |
| <a name="input_enable_plan_apply_separation"></a> [enable\_plan\_apply\_separation](#input\_enable\_plan\_apply\_separation) | Separate Vault roles for plan (read-only) vs apply (write). | `bool` | `false` | no |
| <a name="input_enable_sentinel_policies"></a> [enable\_sentinel\_policies](#input\_enable\_sentinel\_policies) | Attach Sentinel policy sets to the project. Needs TFC Standard+ or TFE Plus. | `bool` | `false` | no |
| <a name="input_enable_vault_backed_aws_auth"></a> [enable\_vault\_backed\_aws\_auth](#input\_enable\_vault\_backed\_aws\_auth) | Enable native AWS Dynamic Provider Credentials via Vault (TFC\_VAULT\_BACKED\_AWS\_AUTH). Can be used even if engine is created externally. | `bool` | `false` | no |
| <a name="input_enable_vault_integration"></a> [enable\_vault\_integration](#input\_enable\_vault\_integration) | Toggle Vault JWT auth, roles, policies, and dynamic creds on workspaces. | `bool` | `true` | no |
| <a name="input_enable_vault_namespace"></a> [enable\_vault\_namespace](#input\_enable\_vault\_namespace) | Create a dedicated app namespace in Vault (Enterprise/HCP only). | `bool` | `false` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | Environments to create. Each gets a workspace + Vault role. | `list(string)` | <pre>[<br/>  "dev",<br/>  "prod"<br/>]</pre> | no |
| <a name="input_kv_secrets_path"></a> [kv\_secrets\_path](#input\_kv\_secrets\_path) | KV v2 mount path (relative to app namespace). | `string` | `"secret"` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | TFC/TFE organization name. | `string` | n/a | yes |
| <a name="input_platform_type"></a> [platform\_type](#input\_platform\_type) | Set to 'hcp' or 'enterprise' depending on your Terraform/Vault stack. | `string` | `"hcp"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name for the landing zone. Workspaces and variable sets are scoped here. | `string` | n/a | yes |
| <a name="input_provider_role_arn"></a> [provider\_role\_arn](#input\_provider\_role\_arn) | AWS Role ARN / GCP SA email / Azure Client ID for OIDC. | `string` | `""` | no |
| <a name="input_run_task_ids"></a> [run\_task\_ids](#input\_run\_task\_ids) | Run Task IDs to attach (Checkov, Infracost, etc). | `list(string)` | `[]` | no |
| <a name="input_run_trigger_source_workspace_ids"></a> [run\_trigger\_source\_workspace\_ids](#input\_run\_trigger\_source\_workspace\_ids) | Workspace IDs whose successful runs trigger this app's workspaces. | `list(string)` | `[]` | no |
| <a name="input_sentinel_policy_set_ids"></a> [sentinel\_policy\_set\_ids](#input\_sentinel\_policy\_set\_ids) | Sentinel policy set IDs to attach. | `list(string)` | `[]` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook for notifications. Empty = disabled. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags for all taggable resources. | `map(string)` | `{}` | no |
| <a name="input_team_access"></a> [team\_access](#input\_team\_access) | Team name → access level mapping for the project. | <pre>map(object({<br/>    access = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | TFE hostname. Only relevant when platform\_type = 'enterprise'. | `string` | `"app.terraform.io"` | no |
| <a name="input_variable_set_ids"></a> [variable\_set\_ids](#input\_variable\_set\_ids) | Variable Set IDs to attach to the project. | `list(string)` | `[]` | no |
| <a name="input_vault_audience"></a> [vault\_audience](#input\_vault\_audience) | Audience claim for workload identity tokens. Must match JWT role bound\_audiences. | `string` | `"vault.workload.identity"` | no |
| <a name="input_vault_aws_auth_mount"></a> [vault\_aws\_auth\_mount](#input\_vault\_aws\_auth\_mount) | Mount path for Vault AWS secrets engine. Used by DPC. | `string` | `"aws"` | no |
| <a name="input_vault_backed_aws_auth_type"></a> [vault\_backed\_aws\_auth\_type](#input\_vault\_backed\_aws\_auth\_type) | The default credential type Vault vends for AWS (iam\_user, assumed\_role, federation\_token). | `string` | `"assumed_role"` | no |
| <a name="input_vault_backed_aws_auth_type_map"></a> [vault\_backed\_aws\_auth\_type\_map](#input\_vault\_backed\_aws\_auth\_type\_map) | Optional overrides for AWS auth type per environment. | `map(string)` | `{}` | no |
| <a name="input_vault_custom_policy_hcl"></a> [vault\_custom\_policy\_hcl](#input\_vault\_custom\_policy\_hcl) | Custom policies as name => HCL. Created and attached alongside vault\_policies. | `map(string)` | `{}` | no |
| <a name="input_vault_jwt_auth_path"></a> [vault\_jwt\_auth\_path](#input\_vault\_jwt\_auth\_path) | JWT auth mount path. Change if 'jwt' is already taken. | `string` | `"jwt"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Parent Vault namespace ('admin' for HCP Vault, or your root namespace for Enterprise). | `string` | `""` | no |
| <a name="input_vault_namespace_path"></a> [vault\_namespace\_path](#input\_vault\_namespace\_path) | Namespace path relative to vault\_namespace. Defaults to application\_name. | `string` | `""` | no |
| <a name="input_vault_policies"></a> [vault\_policies](#input\_vault\_policies) | Extra Vault policy names to attach to roles (base self-manage policy is always included). | `list(string)` | `[]` | no |
| <a name="input_vault_token_max_ttl"></a> [vault\_token\_max\_ttl](#input\_vault\_token\_max\_ttl) | Max TTL (seconds). Tokens can't renew past this. | `number` | `2400` | no |
| <a name="input_vault_token_ttl"></a> [vault\_token\_ttl](#input\_vault\_token\_ttl) | Default TTL (seconds) for workspace Vault tokens. 1200 = 20min per HC recommendation. | `number` | `1200` | no |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault cluster URL (e.g. https://vault.example.com:8200). | `string` | `""` | no |
| <a name="input_workspace_additional_variables"></a> [workspace\_additional\_variables](#input\_workspace\_additional\_variables) | Extra env or terraform variables to inject into all workspaces. | <pre>map(object({<br/>    value     = string<br/>    category  = optional(string, "env")<br/>    sensitive = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_workspace_auto_apply"></a> [workspace\_auto\_apply](#input\_workspace\_auto\_apply) | Auto-apply successful plans. | `bool` | `false` | no |
| <a name="input_workspace_tags"></a> [workspace\_tags](#input\_workspace\_tags) | Tags for all workspaces. | `list(string)` | <pre>[<br/>  "managed-by-landing-zone"<br/>]</pre> | no |
| <a name="input_workspace_terraform_version"></a> [workspace\_terraform\_version](#input\_workspace\_terraform\_version) | Terraform version constraint for workspaces. | `string` | `">= 1.6.0"` | no |
| <a name="input_workspace_vcs_repo"></a> [workspace\_vcs\_repo](#input\_workspace\_vcs\_repo) | VCS repo config. null = CLI-driven workspaces. | <pre>object({<br/>    identifier     = string<br/>    branch         = optional(string, "main")<br/>    oauth_token_id = optional(string)<br/>    tags_regex     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_workspace_working_directory_pattern"></a> [workspace\_working\_directory\_pattern](#input\_workspace\_working\_directory\_pattern) | Working directory pattern; {environment} is replaced per workspace (e.g. 'envs/{environment}'). | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

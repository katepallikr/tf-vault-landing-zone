# Basic Example

Minimum config: one project, two workspaces, Vault wired up.

## What Gets Created

- One HCP Terraform project
- Two workspaces (dev, prod)
- JWT auth backend in Vault (if not already present)
- One Vault role per workspace with bound claims
- Base token self-management policy

## Prerequisites

1. An HCP Terraform organization with an API token
2. An HCP Vault Dedicated cluster (or Vault Enterprise)
3. A Vault token with permission to manage auth backends and policies

## Usage

```bash
export TFE_TOKEN="your-tfe-org-token"
export VAULT_ADDR="https://vault.example.com:8200"
export VAULT_TOKEN="your-vault-token"
export VAULT_NAMESPACE="admin"

terraform init
terraform plan -var="organization_name=my-org" -var="vault_url=$VAULT_ADDR"
terraform apply -var="organization_name=my-org" -var="vault_url=$VAULT_ADDR"
```

## Next Steps

After applying, connect application workspaces to a VCS repository and
add your infrastructure code. The Vault provider will authenticate
automatically using the configured workload identity.

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
| <a name="module_app_landing_zone"></a> [app\_landing\_zone](#module\_app\_landing\_zone) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Short name for the application. | `string` | `"my-app"` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | HCP Terraform organization name. | `string` | n/a | yes |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Full URL of the Vault cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | ID of the created project. |
| <a name="output_vault_role_names"></a> [vault\_role\_names](#output\_vault\_role\_names) | Map of environments to their Vault role names. |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | Map of environment names to workspace IDs. |
<!-- END_TF_DOCS -->

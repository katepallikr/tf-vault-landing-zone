# terraform-tfc-run-tasks

Attaches a run task (Checkov, Infracost, etc) to workspaces.

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
| [tfe_workspace_run_task.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_run_task) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enforcement_level"></a> [enforcement\_level](#input\_enforcement\_level) | Enforcement level: 'advisory' or 'mandatory'. | `string` | `"advisory"` | no |
| <a name="input_run_task_id"></a> [run\_task\_id](#input\_run\_task\_id) | Run Task ID to attach. | `string` | n/a | yes |
| <a name="input_workspace_ids"></a> [workspace\_ids](#input\_workspace\_ids) | Workspace ID map. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

# terraform-tfc-notifications

Slack webhook notifications on workspace runs. Triggers on errors and needs_attention by default.

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
| [tfe_notification_configuration.slack](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/notification_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_notification_name"></a> [notification\_name](#input\_notification\_name) | Notification config name. | `string` | `"slack-alerts"` | no |
| <a name="input_notification_triggers"></a> [notification\_triggers](#input\_notification\_triggers) | Triggers list. | `list(string)` | <pre>[<br/>  "run:errored",<br/>  "run:needs_attention"<br/>]</pre> | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL. | `string` | n/a | yes |
| <a name="input_workspace_ids"></a> [workspace\_ids](#input\_workspace\_ids) | Workspace ID map. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

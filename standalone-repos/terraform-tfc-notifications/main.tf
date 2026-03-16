terraform {
  required_version = ">= 1.6.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.58.0"
    }
  }
}

variable "workspace_ids" {
  description = "Workspace ID map."
  type        = map(string)
}

variable "slack_webhook_url" {
  description = "Slack webhook URL."
  type        = string
  sensitive   = true
}

variable "notification_name" {
  description = "Notification config name."
  type        = string
  default     = "slack-alerts"
}

variable "notification_triggers" {
  description = "Triggers list."
  type        = list(string)
  default     = ["run:errored", "run:needs_attention"]
}

resource "tfe_notification_configuration" "slack" {
  for_each         = var.workspace_ids
  name             = var.notification_name
  enabled          = true
  destination_type = "slack"
  triggers         = var.notification_triggers
  url              = var.slack_webhook_url
  workspace_id     = each.value
}

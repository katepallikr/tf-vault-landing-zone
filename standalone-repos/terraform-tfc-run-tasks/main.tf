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
  description = "Map of workspace keys to their IDs."
  type        = map(string)
}

variable "run_task_id" {
  description = "The ID of the TFE Run Task (e.g., Checkov, Infracost) to attach."
  type        = string
}

variable "enforcement_level" {
  description = "Enforcement level: 'advisory' or 'mandatory'."
  type        = string
  default     = "advisory"
}

resource "tfe_workspace_run_task" "this" {
  for_each          = var.workspace_ids
  workspace_id      = each.value
  task_id           = var.run_task_id
  enforcement_level = var.enforcement_level

  lifecycle {
    precondition {
      condition     = contains(["advisory", "mandatory"], var.enforcement_level)
      error_message = "Enforcement level must be either 'advisory' or 'mandatory'."
    }
  }
}

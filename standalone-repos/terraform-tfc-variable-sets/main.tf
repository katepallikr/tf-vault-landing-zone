terraform {
  required_version = ">= 1.6.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.58.0"
    }
  }
}

variable "project_id" {
  description = "The ID of the TFE project to attach variable sets to."
  type        = string
}

variable "variable_set_ids" {
  description = "List of Variable Set IDs to attach to the project."
  type        = list(string)
  default     = []
}

resource "tfe_project_variable_set" "this" {
  for_each        = toset(var.variable_set_ids)
  project_id      = var.project_id
  variable_set_id = each.value
}

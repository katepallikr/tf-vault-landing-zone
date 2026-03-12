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

variable "cloud_provider" {
  description = "The target cloud provider: 'aws', 'gcp', or 'azure'."
  type        = string
}

variable "provider_role_arn" {
  description = "The ARN of the AWS role, GCP Service Account email, or Azure Client ID to assume via OIDC."
  type        = string
}

# -----------------------------------------------------------------------------
# Workload Identity Constants (Cloud-neutral logic)
# -----------------------------------------------------------------------------

locals {
  is_aws   = var.cloud_provider == "aws"
  is_gcp   = var.cloud_provider == "gcp"
  is_azure = var.cloud_provider == "azure"

  # AWS Provider env vars
  aws_vars = {
    TFC_AWS_PROVIDER_AUTH = "true"
    TFC_AWS_RUN_ROLE_ARN  = var.provider_role_arn
  }

  # GCP Provider env vars
  gcp_vars = {
    TFC_GCP_PROVIDER_AUTH             = "true"
    TFC_GCP_WORKLOAD_PROVIDER_NAME    = var.provider_role_arn # Example placeholder map
    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL = var.provider_role_arn
  }

  # Azure Provider env vars
  azure_vars = {
    TFC_AZURE_PROVIDER_AUTH = "true"
    TFC_AZURE_RUN_CLIENT_ID = var.provider_role_arn
  }

  active_vars = (
    local.is_aws ? local.aws_vars :
    local.is_gcp ? local.gcp_vars :
    local.is_azure ? local.azure_vars : {}
  )
}

resource "tfe_variable" "oidc" {
  # Create a composite key map: "{workspace_key}_{var_name}" => var_value
  for_each = {
    for pair in flatten([
      for ws_key, ws_id in var.workspace_ids : [
        for var_name, var_value in local.active_vars : {
          key      = "${ws_key}-${var_name}"
          ws_id    = ws_id
          category = "env"
          name     = var_name
          value    = var_value
        }
      ]
    ]) : pair.key => pair
  }

  workspace_id = each.value.ws_id
  key          = each.value.name
  value        = each.value.value
  category     = each.value.category
  description  = "OIDC Config for ${var.cloud_provider} injected by Landing Zone"

  lifecycle {
    precondition {
      condition     = var.provider_role_arn != ""
      error_message = "You must provide a valid provider_role_arn when enabling cloud OIDC."
    }
    precondition {
      condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
      error_message = "The cloud_provider must be 'aws', 'gcp', or 'azure'."
    }
  }
}

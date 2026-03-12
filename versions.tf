# Landing Zone Module — Provider and Terraform Version Constraints
#
# Supports both HCP Terraform (cloud) and Terraform Enterprise (self-hosted),
# as well as HCP Vault Dedicated and Vault Enterprise.
#
# Provider configuration belongs in the root module calling this module,
# not here. This file only declares version constraints.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.58.0, < 1.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0.0, < 6.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "hashicorp-kranthi"
    workspaces {
      name = "payment-api-tfc-dev"
    }
  }
}

provider "vault" {
  # Vault Address and token will be automatically injected by Terraform Cloud
  # via the TFC_VAULT_ADDR and TFC_VAULT_RUN_ROLE variables populated by the Golden Module.
}

provider "aws" {
  region     = var.aws_region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token

  # Required when injecting credentials dynamically from a data source 
  # created in the same apply lifecycle.
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}

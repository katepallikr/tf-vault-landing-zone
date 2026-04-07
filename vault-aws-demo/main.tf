terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "root"
}

module "vault_aws" {
  source = "../standalone-repos/terraform-vault-aws"

  vault_namespace  = ""
  application_name = "demo-app"

  vault_aws_access_key = "AKIAIOSFODNN7EXAMPLE"
  vault_aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

  roles = {
    "demo-role" = {
      iam_role_arn = "arn:aws:iam::123456789012:role/demo-assumed-role"
    }
  }
}

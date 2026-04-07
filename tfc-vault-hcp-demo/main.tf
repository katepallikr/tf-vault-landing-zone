terraform {
  cloud {
    organization = "hashicorp-kranthi"
    workspaces {
      name = "vault-aws-hcp-demo"
    }
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

provider "vault" {
  address   = "https://vault-cluster-public-vault-d73c9b8f.dfa4b06b.z1.hashicorp.cloud:8200"
  token     = "hvs.CAESIJY1zV1c6dcm2WzbM4JzJpAVmJm-MOfCci5yG1hxJXMDGikKImh2cy5Yc3NYZVc3d1dHSmQ0eVlhWnZTR0pCNEkueEJNSlAQicbWCg"
  namespace = "admin"
}

module "vault_aws" {
  source = "./terraform-vault-aws"

  vault_namespace  = ""
  application_name = "hcp-aws-demo"

  vault_aws_access_key = "AKIAZBNNS3LERBPBY6GE"
  vault_aws_secret_key = "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"

  roles = {
    "hcp-demo-role" = {
      iam_role_arn    = "arn:aws:iam::123456789012:role/hcp-demo-assumed-role"
      credential_type = "assumed_role"
    }
  }
}

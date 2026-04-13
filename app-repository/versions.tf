terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "hashicorp-kranthi"
    workspaces {
      name = "payment-api-dev"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

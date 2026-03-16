# Application Implementation
# Team: payment-api

# --- Mount Application-specific AWS Secrets Engine ---
module "vault_aws_auth" {
  source = "../standalone-repos/terraform-vault-aws"

  vault_namespace  = "" # HCP Vault Dedicated root
  application_name = "payment-api"
  region           = var.aws_region

  # Base credentials for Vault to manage this specific AWS engine
  vault_aws_access_key = var.vault_aws_access_key
  vault_aws_secret_key = var.vault_aws_secret_key

  roles = {
    "app-admin" = {
      iam_role_arn = var.application_iam_role_arn
    }
  }

  tfc_workspace_vault_roles = [
    "payment-api-tfc-dev",
    "payment-api-tfc-prod"
  ]
}

# --- Acquire STS Credentials ---
data "vault_aws_access_credentials" "creds" {
  backend = module.vault_aws_auth.backend_path
  role    = element(module.vault_aws_auth.roles, 0)
  type    = "sts"

  # Do not read until the mount exists
  depends_on = [module.vault_aws_auth]
}

# --- Provision AWS Infrastructure ---
resource "aws_s3_bucket" "app_storage" {
  bucket_prefix = "payment-api-data-"

  tags = {
    Environment = terraform.workspace
    ManagedBy   = "Vault-OIDC-Injected-Terraform"
  }
}

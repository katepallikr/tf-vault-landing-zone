# Application Implementation
# This file represents the infrastructure managed by the 'payment-api' team.

# -----------------------------------------------------------------------------
# 1. Mount Application-specific AWS Secrets Engine
# Instead of polluting the Golden Module, the application team invokes the Lego 
# block to mount their own AWS identity paths dynamically.
# -----------------------------------------------------------------------------
module "vault_aws_auth" {
  source = "../standalone-repos/terraform-vault-aws"

  vault_namespace  = "" # HCP Vault Dedicated root
  application_name = "payment-api"
  region           = var.aws_region

  # Pass the foundational AWS keys exactly one time to initialize the engine
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

# -----------------------------------------------------------------------------
# 2. Acquire STS Credentials
# The application fetches the dynamically generated AWS credentials using the Vault 
# provider (authenticated seamlessly via OIDC).
# -----------------------------------------------------------------------------
data "vault_aws_access_credentials" "creds" {
  backend = module.vault_aws_auth.backend_path
  role    = element(module.vault_aws_auth.roles, 0)
  type    = "sts"

  # Enforce order: Do not try to read credentials until the mount exists.
  depends_on = [module.vault_aws_auth]
}

# -----------------------------------------------------------------------------
# 3. Provision AWS Infrastructure
# We create an S3 bucket to prove the STS credentials securely injected by Vault work!
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "app_storage" {
  bucket_prefix = "payment-api-data-"

  tags = {
    Environment = terraform.workspace
    ManagedBy   = "Vault-OIDC-Injected-Terraform"
  }
}

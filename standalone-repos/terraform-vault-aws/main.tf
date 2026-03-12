# Vault AWS Secrets Engine Submodule
#
# Mounts the AWS secrets engine and configures roles to issue
# dynamic AWS credentials (STS Assumed Roles) for applications.

# -----------------------------------------------
# Secrets Engine Mount
# -----------------------------------------------

resource "vault_aws_secret_backend" "aws" {
  namespace   = var.vault_namespace != "" ? var.vault_namespace : null
  path        = var.mount_path
  description = "AWS Secrets Engine for ${var.application_name}"
  region      = var.region

  # Only pass credentials if they are provided; otherwise Vault
  # relies on its own underlying IAM instance profile / workload identity.
  access_key = var.vault_aws_access_key
  secret_key = var.vault_aws_secret_key

  # General performance tuning for generic AWS accounts
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 14400
}

# -----------------------------------------------
# Dynamic Roles Configuration
# -----------------------------------------------

# Maps a Vault logical role name to a physical AWS IAM Role ARN
resource "vault_aws_secret_backend_role" "assumed_roles" {
  for_each = var.roles

  namespace       = var.vault_namespace != "" ? var.vault_namespace : null
  backend         = vault_aws_secret_backend.aws.path
  name            = each.key
  credential_type = each.value.credential_type
  role_arns       = [each.value.iam_role_arn]
  default_sts_ttl = each.value.default_sts_ttl
  max_sts_ttl     = each.value.max_sts_ttl
}

# -----------------------------------------------
# Terraform Workspace Policy Integration
# -----------------------------------------------

# Automatically creates a read policy so that Terraform Workspaces
# can request credentials from the roles defined above.
resource "vault_policy" "tfc_aws_secrets_reader" {
  count = length(var.tfc_workspace_vault_roles) > 0 ? 1 : 0

  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  name      = "${var.application_name}-aws-secrets-reader"

  policy = <<-HCL
    # Grant access to read all credentials within this specific AWS mount
    %{for role_name in keys(var.roles)}
    path "${vault_aws_secret_backend.aws.path}/creds/${role_name}" {
      capabilities = ["read"]
    }
    
    # Required for STS AssumeRole tokens
    path "${vault_aws_secret_backend.aws.path}/sts/${role_name}" {
      capabilities = ["read"]
    }
    %{endfor}
  HCL
}

# In a real environment, you would use vault_jwt_auth_backend_role_policy 
# or an orchestrator to attach this policy to the TFC workspace tokens.
# Since TFC workspace tokens are managed in a separate repository (terraform-vault-auth),
# we export the policy name so the orchestrator can attach it over there.

# Mounts AWS secrets engine and configures STS assumed roles.
# Secrets Engine Mount

resource "vault_aws_secret_backend" "aws" {
  namespace   = var.vault_namespace != "" ? var.vault_namespace : null
  path        = var.mount_path
  description = "AWS Secrets Engine for ${var.application_name}"
  region      = var.region

  # Vault uses its own instance profile if creds aren't passed
  access_key = var.vault_aws_access_key
  secret_key = var.vault_aws_secret_key

  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 14400
}

# Dynamic Roles Configuration

# Map Vault logical role -> AWS IAM Role ARN
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

# Terraform Workspace Policy Integration

# Read policy for TFC workspaces to request these creds.
resource "vault_policy" "tfc_aws_secrets_reader" {
  count = length(var.tfc_workspace_vault_roles) > 0 ? 1 : 0

  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  name      = "${var.application_name}-aws-secrets-reader"

  policy = <<-HCL
    # Allow reading creds
    %{for role_name in keys(var.roles)}
    path "${vault_aws_secret_backend.aws.path}/creds/${role_name}" {
      capabilities = ["read"]
    }
    
    # For STS AssumeRole tokens
    path "${vault_aws_secret_backend.aws.path}/sts/${role_name}" {
      capabilities = ["read"]
    }
    %{endfor}
  HCL
}

# TFC workspace tokens are managed in terraform-vault-auth.
# Export this policy name so the orchestrator can attach it over there.

# Mounts GCP secrets engine and configures rolesets.

resource "vault_gcp_secret_backend" "gcp" {
  namespace   = var.vault_namespace != "" ? var.vault_namespace : null
  path        = var.mount_path
  description = "GCP Secrets Engine for ${var.application_name}"

  credentials = var.credentials
}

# Dynamic Roles Configuration
resource "vault_gcp_secret_roleset" "rolesets" {
  for_each = var.rolesets

  namespace    = var.vault_namespace != "" ? var.vault_namespace : null
  backend      = vault_gcp_secret_backend.gcp.path
  roleset      = each.key
  secret_type  = each.value.secret_type
  project      = var.project_id
  token_scopes = each.value.token_scopes

  dynamic "binding" {
    for_each = each.value.bindings
    content {
      resource = binding.value.resource
      roles    = binding.value.roles
    }
  }
}

# Terraform Workspace Policy Integration
# Read policy for TFC workspaces to request these creds.
resource "vault_policy" "tfc_gcp_secrets_reader" {
  count = length(var.tfc_workspace_vault_roles) > 0 ? 1 : 0

  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  name      = "${var.application_name}-gcp-secrets-reader"

  policy = <<-HCL
    # Allow generating dynamic GCP credentials
    %{for roleset_name, config in var.rolesets}
    # For Service Account Keys or Auth Tokens
    path "${vault_gcp_secret_backend.gcp.path}/${config.secret_type == "access_token" ? "token" : "key"}/${roleset_name}" {
      capabilities = ["read"]
    }
    %{endfor}
  HCL
}

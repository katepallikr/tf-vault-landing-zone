# Mounts Azure secrets engine and configures roles.

resource "vault_azure_secret_backend" "azure" {
  namespace   = var.vault_namespace != "" ? var.vault_namespace : null
  path        = var.mount_path
  description = "Azure Secrets Engine for ${var.application_name}"

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  # For Entra ID/Azure AD identity management if needed
  # environment = "AzurePublicCloud"
}

# Dynamic Roles Configuration
resource "vault_azure_secret_backend_role" "app_roles" {
  for_each = var.roles

  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  backend   = vault_azure_secret_backend.azure.path
  role      = each.key
  ttl       = each.value.default_ttl
  max_ttl   = each.value.max_ttl

  # Provide explicit mapped permissions to the generated Service Principals
  dynamic "azure_roles" {
    for_each = each.value.azure_roles
    content {
      role_name = azure_roles.value.role_name
      scope     = azure_roles.value.scope
    }
  }
}

# Terraform Workspace Policy Integration
# Read policy for TFC workspaces to request these creds.
resource "vault_policy" "tfc_azure_secrets_reader" {
  count = length(var.tfc_workspace_vault_roles) > 0 ? 1 : 0

  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  name      = "${var.application_name}-azure-secrets-reader"

  policy = <<-HCL
    # Allow generating dynamic Azure credentials
    %{for role_name in keys(var.roles)}
    path "${vault_azure_secret_backend.azure.path}/creds/${role_name}" {
      capabilities = ["read"]
    }
    %{endfor}
  HCL
}

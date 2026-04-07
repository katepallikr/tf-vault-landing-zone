mock_provider "vault" {}

variables {
  application_name          = "test-azure-app"
  subscription_id           = "00000000-0000-0000-0000-000000000000"
  tenant_id                 = "00000000-0000-0000-0000-000000000000"
  client_id                 = "00000000-0000-0000-0000-000000000000"
  client_secret             = "dummy-secret"
  tfc_workspace_vault_roles = ["mock-workspace-role"]

  roles = {
    "dev-contributor" = {
      default_ttl = 3600
      max_ttl     = 14400
      azure_roles = [
        {
          role_name = "Contributor"
          scope     = "/subscriptions/00000000-0000-0000-0000-000000000000"
        }
      ]
    }
  }
}

run "validate_azure_vault_backend" {
  command = plan
  assert {
    condition     = vault_azure_secret_backend.azure.path == "azure"
    error_message = "Vault Azure backend was not correctly mounted to 'azure'."
  }

  assert {
    condition     = vault_azure_secret_backend_role.app_roles["dev-contributor"].role == "dev-contributor"
    error_message = "Vault Azure backend role 'dev-contributor' failed to provision."
  }
}

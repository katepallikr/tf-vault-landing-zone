# Validates optional resource toggles (Vault, namespaces, etc).

mock_provider "tfe" {}
mock_provider "vault" {}

variables {
  organization_name        = "test-org"
  project_name             = "flags-project"
  application_name         = "flag-app"
  environments             = ["dev"]
  enable_vault_integration = false
  enable_vault_namespace   = false
  vault_url                = ""
}

run "vault_disabled_creates_no_auth_resources" {
  command = plan

  assert {
    condition     = length(module.vault_auth) == 0
    error_message = "Vault auth module should not be instantiated when integration is disabled."
  }
}

run "vault_disabled_creates_no_namespace" {
  command = plan

  assert {
    condition     = length(module.vault_namespace) == 0
    error_message = "Vault namespace module should not be instantiated when disabled."
  }
}

run "vault_enabled_creates_auth_resources" {
  command = plan

  variables {
    enable_vault_integration = true
    vault_url                = "https://vault.example.com:8200"
    vault_namespace          = "admin"
  }

  assert {
    condition     = length(module.vault_auth) == 1
    error_message = "Vault auth module should be instantiated when integration is enabled."
  }
}

run "platform_type_hcp_resolves_hostname" {
  command = plan

  variables {
    platform_type = "hcp"
  }

  assert {
    condition     = output.tfc_hostname == "app.terraform.io"
    error_message = "HCP platform should resolve to app.terraform.io."
  }
}

run "platform_type_enterprise_uses_custom_hostname" {
  command = plan

  variables {
    platform_type = "enterprise"
    tfe_hostname  = "tfe.internal.corp.com"
  }

  assert {
    condition     = output.tfc_hostname == "tfe.internal.corp.com"
    error_message = "Enterprise platform should use the provided hostname."
  }
}

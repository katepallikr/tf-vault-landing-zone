# Input Validation Tests
#
# Confirms that variable validation rules reject invalid inputs.

mock_provider "tfe" {}
mock_provider "vault" {}

run "rejects_invalid_platform_type" {
  command = plan

  variables {
    organization_name = "test-org"
    project_name      = "test-proj"
    application_name  = "test-app"
    platform_type     = "azure"
  }

  expect_failures = [var.platform_type]
}

run "rejects_uppercase_application_name" {
  command = plan

  variables {
    organization_name = "test-org"
    project_name      = "test-proj"
    application_name  = "MyApp"
  }

  expect_failures = [var.application_name]
}

run "rejects_invalid_environments" {
  command = plan

  variables {
    organization_name = "test-org"
    project_name      = "test-proj"
    application_name  = "test-app"
    environments      = ["dev", "production"]
  }

  expect_failures = [var.environments]
}

run "rejects_duplicate_environments" {
  command = plan

  variables {
    organization_name = "test-org"
    project_name      = "test-proj"
    application_name  = "test-app"
    environments      = ["dev", "dev"]
  }

  expect_failures = [var.environments]
}

run "rejects_token_ttl_below_minimum" {
  command = plan

  variables {
    organization_name        = "test-org"
    project_name             = "test-proj"
    application_name         = "test-app"
    enable_vault_integration = true
    vault_url                = "https://v.example.com"
    vault_token_ttl          = 60
  }

  expect_failures = [var.vault_token_ttl]
}

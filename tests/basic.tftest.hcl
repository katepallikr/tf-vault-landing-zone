# Basic Validation Tests
#
# Verifies core module behavior using mock providers.
# No real infrastructure is created — safe to run in CI.

mock_provider "tfe" {}
mock_provider "vault" {}

variables {
  organization_name = "test-org"
  project_name      = "test-project"
  application_name  = "test-app"
  environments      = ["dev", "prod"]
  vault_url         = "https://vault.example.com:8200"
  vault_namespace   = "admin"
}

run "creates_project_for_application" {
  command = plan

  assert {
    condition     = module.workspace.project_name == "test-project"
    error_message = "Project name should match the input variable."
  }
}

run "creates_one_workspace_per_environment" {
  command = plan

  assert {
    condition     = length(keys(module.workspace.workspace_ids)) == 2
    error_message = "Should create exactly two workspaces for dev and prod."
  }
}

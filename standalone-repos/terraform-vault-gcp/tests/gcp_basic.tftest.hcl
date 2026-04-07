mock_provider "vault" {}

variables {
  application_name          = "test-gcp-app"
  credentials               = "{ \"type\": \"service_account\", \"project_id\": \"mock-project\" }"
  project_id                = "mock-project"
  tfc_workspace_vault_roles = ["mock-workspace-role"]

  rolesets = {
    "dev-viewer" = {
      secret_type  = "access_token"
      token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
      bindings = [
        {
          resource = "//cloudresourcemanager.googleapis.com/projects/mock-project"
          roles    = ["roles/viewer"]
        }
      ]
    }
  }
}

run "validate_gcp_vault_backend" {
  command = plan
  assert {
    condition     = vault_gcp_secret_backend.gcp.path == "gcp"
    error_message = "Vault GCP backend was not correctly mounted to 'gcp'."
  }

  assert {
    condition     = vault_gcp_secret_roleset.rolesets["dev-viewer"].roleset == "dev-viewer"
    error_message = "Vault GCP roleset 'dev-viewer' failed to provision."
  }
}

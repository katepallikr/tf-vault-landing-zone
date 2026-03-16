# Provisions a single project with dev and prod workspaces connected to Vault.

provider "tfe" {}

provider "vault" {
  # Address and token are set via environment variables:
  #   VAULT_ADDR, VAULT_TOKEN, VAULT_NAMESPACE
}

module "app_landing_zone" {
  source = "../../"

  # Platform
  platform_type     = "hcp"
  organization_name = var.organization_name
  project_name      = "${var.application_name}-project"

  # Application
  application_name = var.application_name
  environments     = ["dev", "prod"]

  # Vault
  enable_vault_integration = true
  vault_url                = var.vault_url
  vault_namespace          = "admin"
  vault_jwt_auth_path      = "jwt"
}

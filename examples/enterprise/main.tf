# Self-hosted TFE + Vault Enterprise config (no HCP "admin" prefix).

provider "tfe" {
  hostname = var.tfe_hostname
}

provider "vault" {}

module "erp_landing_zone" {
  source = "../../"

  # Enterprise platform
  platform_type     = "enterprise"
  tfe_hostname      = var.tfe_hostname
  organization_name = var.organization_name
  project_name      = "erp-modernization"

  # Application
  application_name = "erp-gateway"
  environments     = ["dev", "test", "prod"]

  # Workspace settings
  workspace_terraform_version = ">= 1.7.0"

  # Vault Enterprise (no "admin" prefix)
  enable_vault_integration      = true
  vault_url                     = var.vault_url
  vault_namespace               = var.vault_namespace
  vault_jwt_auth_path           = "jwt-tfe"
  create_vault_jwt_auth_backend = true
  vault_token_ttl               = 1800

  # Namespace
  enable_vault_namespace = true
  vault_namespace_path   = "erp-gateway"
}

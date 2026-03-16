# JWT Auth Backend and Roles
# Configures Vault to trust TFC/TFE workload identity tokens. 
# Creates a role per environment with bounded claims.
# -----------------------------------------------
# JWT Auth Backend
# -----------------------------------------------

resource "vault_jwt_auth_backend" "tfc" {
  count = var.create_jwt_backend ? 1 : 0

  namespace          = var.vault_namespace != "" ? var.vault_namespace : null
  path               = var.jwt_auth_path
  type               = "jwt"
  oidc_discovery_url = "https://${var.tfc_hostname}"
  bound_issuer       = "https://${var.tfc_hostname}"

  tune {
    default_lease_ttl = "${var.token_ttl}s"
    max_lease_ttl     = "${var.token_max_ttl}s"
    token_type        = "default-service"
  }
}

# -----------------------------------------------
# Base Policy — Token Self-Management
# -----------------------------------------------

resource "vault_policy" "tfc_base" {
  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  name      = var.base_policy_name

  policy = <<-HCL
    # Required for dynamic provider credentials so tokens can renew/revoke themselves.

    path "auth/token/lookup-self" {
      capabilities = ["read"]
    }

    path "auth/token/renew-self" {
      capabilities = ["update"]
    }

    path "auth/token/revoke-self" {
      capabilities = ["update"]
    }
  HCL
}

# -----------------------------------------------
# Custom Policies
# -----------------------------------------------

resource "vault_policy" "custom" {
  for_each = var.custom_policy_hcl

  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  name      = each.key
  policy    = each.value
}

# -----------------------------------------------
# JWT Auth Roles — One Per Environment
# -----------------------------------------------

data "vault_auth_backend" "existing" {
  count     = var.create_jwt_backend ? 0 : 1
  namespace = var.vault_namespace != "" ? var.vault_namespace : null
  path      = var.jwt_auth_path

  lifecycle {
    postcondition {
      condition     = self.type == "jwt"
      error_message = "The Vault auth backend at path '${var.jwt_auth_path}' does not exist or is not of type 'jwt'."
    }
  }
}

locals {
  jwt_backend_path = var.create_jwt_backend ? vault_jwt_auth_backend.tfc[0].path : data.vault_auth_backend.existing[0].path
}

# Standard role: both plan and apply phases
resource "vault_jwt_auth_backend_role" "workspace" {
  for_each = var.enable_plan_apply_separation ? {} : var.vault_role_map

  namespace      = var.vault_namespace != "" ? var.vault_namespace : null
  backend        = local.jwt_backend_path
  role_name      = each.value.role_name
  token_policies = var.role_token_policies

  bound_audiences   = [var.vault_audience]
  bound_claims_type = "glob"
  bound_claims = {
    sub = each.value.bound_claim
  }

  user_claim    = "terraform_full_workspace"
  role_type     = "jwt"
  token_ttl     = var.token_ttl
  token_max_ttl = var.token_max_ttl

  lifecycle {
    precondition {
      condition     = length(var.role_token_policies) > 0
      error_message = "Vault roles must have at least one policy attached to prevent escalating to root."
    }
  }
}

# Plan-only role: read access for speculative plans
resource "vault_jwt_auth_backend_role" "plan" {
  for_each = var.enable_plan_apply_separation ? var.vault_role_map : {}

  namespace      = var.vault_namespace != "" ? var.vault_namespace : null
  backend        = local.jwt_backend_path
  role_name      = each.value.plan_role_name
  token_policies = var.role_token_policies

  bound_audiences   = [var.vault_audience]
  bound_claims_type = "glob"
  bound_claims = {
    sub = each.value.plan_bound_claim
  }

  user_claim    = "terraform_full_workspace"
  role_type     = "jwt"
  token_ttl     = var.token_ttl
  token_max_ttl = var.token_max_ttl

  lifecycle {
    precondition {
      condition     = length(var.role_token_policies) > 0
      error_message = "Vault plan roles must have at least one policy attached to prevent escalating to root."
    }
  }
}

# Apply role: full access for applies
resource "vault_jwt_auth_backend_role" "apply" {
  for_each = var.enable_plan_apply_separation ? var.vault_role_map : {}

  namespace      = var.vault_namespace != "" ? var.vault_namespace : null
  backend        = local.jwt_backend_path
  role_name      = each.value.role_name
  token_policies = var.role_token_policies

  bound_audiences   = [var.vault_audience]
  bound_claims_type = "glob"
  bound_claims = {
    sub = each.value.apply_bound_claim
  }

  user_claim    = "terraform_full_workspace"
  role_type     = "jwt"
  token_ttl     = var.token_ttl
  token_max_ttl = var.token_max_ttl

  lifecycle {
    precondition {
      condition     = length(var.role_token_policies) > 0
      error_message = "Vault apply roles must have at least one policy attached to prevent escalating to root."
    }
  }
}

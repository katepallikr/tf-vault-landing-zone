terraform {
  required_version = ">= 1.6.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.50.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.23.0"
    }
  }
}

locals {
  # Workspace naming convention
  workspace_map = {
    for env in var.environments : env => {
      workspace_name = "${var.application_name}-${env}"
      environment    = env
      working_dir    = var.workspace_working_directory_pattern != "" ? replace(var.workspace_working_directory_pattern, "{environment}", env) : ""
    }
  }

  # Vault role naming convention
  vault_role_map = {
    for env in var.environments : env => {
      role_name         = "${var.application_name}-tfc-${env}"
      plan_role_name    = "${var.application_name}-tfc-${env}-plan"
      bound_claim       = "organization:${var.organization_name}:project:${var.project_name}:workspace:${var.application_name}-${env}:run_phase:*"
      plan_bound_claim  = "organization:${var.organization_name}:project:${var.project_name}:workspace:${var.application_name}-${env}:run_phase:plan"
      apply_bound_claim = "organization:${var.organization_name}:project:${var.project_name}:workspace:${var.application_name}-${env}:run_phase:apply"
    }
  }

  vault_base_policy_name    = "${var.application_name}-tfc-base"
  vault_all_custom_policies = keys(var.vault_custom_policy_hcl)
  vault_role_policies       = concat(
    [local.vault_base_policy_name], 
    var.vault_policies, 
    local.vault_all_custom_policies,
    var.enable_vault_backed_aws_auth ? [module.vault_aws_auth[0].reader_policy_name] : []
  )
}

# fetch project and bind workspace
module "workspace" {
  source = "../standalone-repos/terraform-tfe-workspace"

  organization_name = var.organization_name
  project_name      = var.project_name
  create_project    = false # IMPORTANT: Fetches existing project from Tier 1

  application_name     = var.application_name
  workspace_map        = local.workspace_map
  terraform_version    = var.workspace_terraform_version
  auto_apply           = var.workspace_auto_apply
  vcs_repo             = var.workspace_vcs_repo
  workspace_tags       = var.workspace_tags
  team_access          = var.team_access
  additional_variables = var.workspace_additional_variables

  enable_vault_integration     = var.enable_vault_integration
  vault_url                    = var.vault_url
  vault_namespace              = var.vault_namespace
  vault_jwt_auth_path          = var.vault_jwt_auth_path
  vault_audience               = var.vault_audience
  vault_role_map               = local.vault_role_map
  enable_plan_apply_separation = var.enable_plan_apply_separation

  enable_vault_backed_aws_auth   = var.enable_vault_backed_aws_auth
  vault_aws_auth_mount           = var.vault_aws_auth_mount
  vault_backed_aws_auth_type     = var.vault_backed_aws_auth_type
  vault_backed_aws_auth_type_map = var.vault_backed_aws_auth_type_map
  sentinel_policy_set_ids        = var.enable_sentinel_policies ? var.sentinel_policy_set_ids : []
}

# vault app roles
module "vault_auth" {
  source = "../standalone-repos/terraform-vault-auth"
  count  = var.enable_vault_integration ? 1 : 0

  organization_name = var.organization_name
  project_name      = var.project_name
  application_name  = var.application_name

  tfc_hostname       = var.tfe_hostname
  vault_namespace    = var.vault_namespace
  jwt_auth_path      = var.vault_jwt_auth_path
  create_jwt_backend = false # IMPORTANT: Append to Tier 1 backend
  vault_audience     = var.vault_audience

  vault_role_map               = local.vault_role_map
  role_token_policies          = local.vault_role_policies
  token_ttl                    = var.vault_token_ttl
  token_max_ttl                = var.vault_token_max_ttl
  enable_plan_apply_separation = var.enable_plan_apply_separation

  custom_policy_hcl = var.vault_custom_policy_hcl
  base_policy_name  = local.vault_base_policy_name
}

# namespace and sub-engines
module "vault_namespace" {
  source = "../standalone-repos/terraform-vault-namespace"
  count  = var.enable_vault_namespace ? 1 : 0

  namespace_path   = var.vault_namespace_path != "" ? var.vault_namespace_path : var.application_name
  parent_namespace = var.vault_namespace
  application_name = var.application_name

  enable_kv_engine = var.enable_kv_secrets_engine
  kv_mount_path    = var.kv_secrets_path

  enable_aws_engine = var.create_vault_aws_engine
  aws_mount_path    = var.vault_aws_auth_mount
}

# configure the AWS secrets engine and roles for TFC NATIVE DPC
module "vault_aws_auth" {
  source = "../standalone-repos/terraform-vault-aws"
  count  = var.enable_vault_backed_aws_auth ? 1 : 0

  vault_namespace  = var.vault_namespace
  application_name = var.application_name
  region           = var.aws_region
  mount_path       = var.vault_aws_auth_mount

  vault_aws_access_key = var.vault_aws_access_key
  vault_aws_secret_key = var.vault_aws_secret_key

  # NATIVE DPC expects the AWS Secrets Engine Role name to match the TFC Workspace Vault Role name EXACTLY
  roles = {
    for env in var.environments : "${var.application_name}-tfc-${env}" => {
      iam_role_arn = var.application_iam_role_arn
    }
  }

  tfc_workspace_vault_roles = [
    for env in var.environments : "${var.application_name}-tfc-${env}"
  ]

  depends_on = [module.vault_namespace]
}

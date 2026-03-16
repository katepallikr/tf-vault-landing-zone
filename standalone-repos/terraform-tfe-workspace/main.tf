# Provisions TFC/TFE project, workspaces, and injects Vault variables.
resource "tfe_project" "this" {
  organization = var.organization_name
  name         = var.project_name
}

resource "tfe_workspace" "this" {
  for_each = var.workspace_map

  organization      = var.organization_name
  project_id        = tfe_project.this.id
  name              = each.value.workspace_name
  auto_apply        = var.auto_apply
  terraform_version = var.terraform_version
  tag_names         = concat(var.workspace_tags, [each.value.environment])
  working_directory = each.value.working_dir != "" ? each.value.working_dir : null

  dynamic "vcs_repo" {
    for_each = var.vcs_repo != null ? [var.vcs_repo] : []
    content {
      identifier     = vcs_repo.value.identifier
      branch         = vcs_repo.value.branch
      oauth_token_id = vcs_repo.value.oauth_token_id
      tags_regex     = vcs_repo.value.tags_regex
    }
  }
}

data "tfe_team" "this" {
  for_each     = var.team_access
  organization = var.organization_name
  name         = each.key

  lifecycle {
    postcondition {
      condition     = self.id != ""
      error_message = "The team '${each.key}' does not exist in organization '${var.organization_name}'."
    }
  }
}

resource "tfe_team_project_access" "this" {
  for_each   = var.team_access
  project_id = tfe_project.this.id
  team_id    = data.tfe_team.this[each.key].id
  access     = each.value.access
}

# Vault Dynamic Credential Variables

resource "tfe_variable" "vault_provider_auth" {
  for_each     = var.enable_vault_integration ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  description  = "Enable Vault integration."
}

resource "tfe_variable" "vault_addr" {
  for_each     = var.enable_vault_integration ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_ADDR"
  value        = var.vault_url
  category     = "env"
  sensitive    = true
  description  = "Vault URL."
}

resource "tfe_variable" "vault_namespace" {
  for_each     = var.enable_vault_integration && var.vault_namespace != "" ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_NAMESPACE"
  value        = var.vault_namespace
  category     = "env"
  description  = "Vault namespace."
}

resource "tfe_variable" "vault_auth_path" {
  for_each     = var.enable_vault_integration ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_AUTH_PATH"
  value        = var.vault_jwt_auth_path
  category     = "env"
  description  = "JWT auth mount path."
}

resource "tfe_variable" "vault_run_role" {
  for_each     = var.enable_vault_integration && !var.enable_plan_apply_separation ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_RUN_ROLE"
  value        = var.vault_role_map[each.key].role_name
  category     = "env"
  description  = "Workspace Vault role."
}

resource "tfe_variable" "vault_plan_role" {
  for_each     = var.enable_vault_integration && var.enable_plan_apply_separation ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_PLAN_ROLE"
  value        = var.vault_role_map[each.key].plan_role_name
  category     = "env"
  description  = "Vault role for plan."
}

resource "tfe_variable" "vault_apply_role" {
  for_each     = var.enable_vault_integration && var.enable_plan_apply_separation ? var.workspace_map : {}
  workspace_id = tfe_workspace.this[each.key].id
  key          = "TFC_VAULT_APPLY_ROLE"
  value        = var.vault_role_map[each.key].role_name
  category     = "env"
  description  = "Vault role for apply."
}

resource "tfe_variable" "additional" {
  for_each = {
    for pair in setproduct(keys(var.workspace_map), keys(var.additional_variables)) :
    "${pair[0]}-${pair[1]}" => {
      env = pair[0]
      key = pair[1]
      cfg = var.additional_variables[pair[1]]
    }
  }
  workspace_id = tfe_workspace.this[each.value.env].id
  key          = each.value.key
  value        = each.value.cfg.value
  category     = each.value.cfg.category
  sensitive    = each.value.cfg.sensitive
}

resource "tfe_run_trigger" "this" {
  for_each = {
    for pair in setproduct(keys(var.workspace_map), var.run_trigger_source_workspace_ids) :
    "${pair[0]}-${pair[1]}" => { env = pair[0], source_id = pair[1] }
  }
  workspace_id  = tfe_workspace.this[each.value.env].id
  sourceable_id = each.value.source_id
}

resource "tfe_project_policy_set" "this" {
  for_each      = toset(var.sentinel_policy_set_ids)
  project_id    = tfe_project.this.id
  policy_set_id = each.value
}

# resource "tfe_workspace_run_task" "this" {
#   for_each     = var.run_task_ids
#   workspace_id = tfe_workspace.this[each.key].id
#   task_id      = each.value
#   enforcement_level = "advisory"
# }

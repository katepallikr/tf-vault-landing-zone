output "project_id" {
  description = "Project ID."
  value       = local.project_id
}

output "project_name" {
  description = "Project name."
  value       = var.create_project ? tfe_project.this[0].name : data.tfe_project.this[0].name
}

output "workspace_ids" {
  description = "env => workspace ID."
  value       = { for env, ws in tfe_workspace.this : env => ws.id }
}

output "workspace_names" {
  description = "env => workspace name."
  value       = { for env, ws in tfe_workspace.this : env => ws.name }
}

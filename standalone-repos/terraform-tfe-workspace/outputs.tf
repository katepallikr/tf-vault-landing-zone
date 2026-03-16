output "project_id" {
  description = "Project ID."
  value       = tfe_project.this.id
}

output "project_name" {
  description = "Project name."
  value       = tfe_project.this.name
}

output "workspace_ids" {
  description = "env => workspace ID."
  value       = { for env, ws in tfe_workspace.this : env => ws.id }
}

output "workspace_names" {
  description = "env => workspace name."
  value       = { for env, ws in tfe_workspace.this : env => ws.name }
}

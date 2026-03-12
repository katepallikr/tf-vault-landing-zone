output "project_id" {
  description = "ID of the created project."
  value       = tfe_project.this.id
}

output "project_name" {
  description = "Name of the created project."
  value       = tfe_project.this.name
}

output "workspace_ids" {
  description = "Map of environment names to workspace IDs."
  value       = { for env, ws in tfe_workspace.this : env => ws.id }
}

output "workspace_names" {
  description = "Map of environment names to workspace names."
  value       = { for env, ws in tfe_workspace.this : env => ws.name }
}

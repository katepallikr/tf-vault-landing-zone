output "namespace_path" {
  description = "Relative path of the created namespace."
  value       = vault_namespace.this.path
}

output "namespace_path_fq" {
  description = "Fully qualified namespace path."
  value       = vault_namespace.this.path_fq
}

output "kv_mount_path" {
  description = "Mount path of the KV v2 engine, if created."
  value       = var.enable_kv_engine ? vault_mount.kv[0].path : null
}

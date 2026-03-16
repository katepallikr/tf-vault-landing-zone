output "namespace_path" {
  description = "Namespace path."
  value       = vault_namespace.this.path
}

output "namespace_path_fq" {
  description = "Fully qualified path."
  value       = vault_namespace.this.path_fq
}

output "kv_mount_path" {
  description = "KV v2 path (null if not created)."
  value       = var.enable_kv_engine ? vault_mount.kv[0].path : null
}

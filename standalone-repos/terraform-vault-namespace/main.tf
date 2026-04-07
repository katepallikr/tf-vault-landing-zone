# Creates child namespace and optional KV engine.

resource "vault_namespace" "this" {
  namespace = var.parent_namespace != "" ? var.parent_namespace : null
  path      = var.namespace_path

  custom_metadata = merge(
    {
      managed-by  = "terraform-landing-zone"
      application = var.application_name
    },
    var.tags
  )
}

resource "vault_mount" "kv" {
  count = var.enable_kv_engine ? 1 : 0

  namespace   = vault_namespace.this.path_fq
  path        = var.kv_mount_path
  type        = "kv"
  description = "KV v2 secrets engine for ${var.application_name}"

  options = {
    version = "2"
  }
}

resource "vault_aws_secret_backend" "aws" {
  count = var.enable_aws_engine ? 1 : 0

  namespace   = vault_namespace.this.path_fq
  path        = var.aws_mount_path
  description = "AWS Secrets engine for ${var.application_name}"
}

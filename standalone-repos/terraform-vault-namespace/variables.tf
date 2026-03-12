variable "namespace_path" {
  description = "Path for the child namespace relative to the parent."
  type        = string
}

variable "parent_namespace" {
  description = "Parent Vault namespace. Empty string for the root namespace."
  type        = string
  default     = ""
}

variable "enable_kv_engine" {
  description = "Whether to mount a KV v2 secrets engine in the namespace."
  type        = bool
  default     = true
}

variable "kv_mount_path" {
  description = "Mount path for the KV v2 secrets engine."
  type        = string
  default     = "secret"
}

variable "application_name" {
  description = "Application identifier for metadata."
  type        = string
}

variable "tags" {
  description = "Tags to apply as custom metadata on the namespace."
  type        = map(string)
  default     = {}
}

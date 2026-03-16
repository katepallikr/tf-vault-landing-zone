variable "namespace_path" {
  description = "Child namespace path."
  type        = string
}

variable "parent_namespace" {
  description = "Parent namespace (empty = root)."
  type        = string
  default     = ""
}

variable "enable_kv_engine" {
  description = "Mount KV v2 in the namespace."
  type        = bool
  default     = true
}

variable "kv_mount_path" {
  description = "KV v2 mount path."
  type        = string
  default     = "secret"
}

variable "application_name" {
  description = "App name (for metadata)."
  type        = string
}

variable "tags" {
  description = "Custom metadata tags."
  type        = map(string)
  default     = {}
}

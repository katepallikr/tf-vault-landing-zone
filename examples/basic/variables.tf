variable "organization_name" {
  description = "HCP Terraform organization name."
  type        = string
}

variable "application_name" {
  description = "Short name for the application."
  type        = string
  default     = "my-app"
}

variable "vault_url" {
  description = "Full URL of the Vault cluster."
  type        = string
}

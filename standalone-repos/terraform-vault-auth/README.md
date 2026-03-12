# Terraform Vault Auth Module

This standalone Terraform module configures Vault to trust JWTs emitted by HCP Terraform / TFE. It acts natively to establish secure Workload Identity federation.

**Architecture:** When called via the orchestrator, this module verifies the workspace boundaries and establishes least-privilege Vault Roles ensuring that `dev` workspaces can only request `dev` credentials.

# Terraform TFC Run Tasks Module

This standalone module attaches global or organizational-level Run Tasks to specific Terraform Enterprise workspaces.

Use this module (often via the Thin Orchestrator) to enforce Checkov security scanning or Snyk infrastructure scans during the `terraform plan` phase.

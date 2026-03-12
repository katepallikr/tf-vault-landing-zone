# Terraform TFE Workspace Module

This repository is a self-contained "Lego Block" module responsible for provisioning Terraform Enterprise (or HCP Terraform) Projects and Workspaces. 

It manages:
* Project Creation
* Workspace Generation (SDLC environments like "dev" and "prod")
* Vault Variable Mounts (e.g. `TFC_VAULT_RUN_ROLE`)
* Global Configuration Overrides (Auto-apply, execution modes)

**Architecture:** This module integrates smoothly into the larger `landing-zone-orchestrator` process as the primary foundational block.

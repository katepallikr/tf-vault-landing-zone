# Terraform Landing Zone Orchestrator

Automates app onboarding to **HCP Terraform** / **Terraform Enterprise** with optional **Vault** (HCP Vault Dedicated or Enterprise) integration. The landing zone itself is thin — it wires together standalone child modules rather than defining resources directly.

## Architecture: The "Lego Block" Model

This Landing Zone acts as a core assembler. Instead of being a Monolith, the orchestrator consumes independent child modules via Git URLs.

*   Think of the landing zone like **a kid playing with Legos** — each module is a discrete block you snap together.
*   "I need a project and a workspace, but I also need AWS Cloud credentials" → just click the `cloud_oidc` and `vault_aws` modules in using the configuration inputs.
*   Each of these child modules lives in its own repository with an independent SDLC.

```
 ┌────────────────────────────────────────────────────────┐
 │              Main Orchestrator (This Repo)             │
 │                                                        │
 │  Reads Application Inputs and Coordinates Subsystems   │
 │                                                        │
 └─────────────────┬──────────────────────┬───────────────┘
                   │                      │
         ┌─────────▼────────┐   ┌─────────▼─────────────────┐
         │ Terraform Cloud  │   │ Vault Integrations        │
         │ Configuration    │   │                           │
         │                  │   │                           │
         ├── tfe_workspace  │   ├── vault_auth              │
         ├── run_tasks      │   ├── vault_namespace         │
         ├── variable_sets  │   └── vault_aws               │
         └── notifications  │                               │
         └──────────────────┘   └───────────────────────────┘
```

## Features

- **Modular** — Workspace, Vault, and Day 2 ops are separate modules with their own lifecycle
- **Vault integration** — JWT-based workload identity federation with no static credentials stored in Terraform
- **Day 2 ops** — Checkov/Infracost run tasks, Slack alerts, and variable set attachments
- **Cloud OIDC** — AWS/GCP/Azure workload identity without needing Vault

## Module Ecosystem Structure

The orchestrator pulls these child modules from your registry or Git:

- `terraform-tfe-workspace`
- `terraform-vault-auth`
- `terraform-vault-namespace`
- `terraform-tfc-cloud-oidc`
- `terraform-tfc-run-tasks`
- `terraform-tfc-variable-sets`
- `terraform-tfc-notifications`

`terraform-vault-aws` is included for apps that need their own AWS secrets engine mount.

## Quick Start

```hcl
module "app_landing_zone" {
  source  = "git::https://github.com/your-org/terraform-tfe-landing-zone.git?ref=v2.0.0"

  organization_name = "your-org"
  project_name      = "my-app-project"
  application_name  = "my-app"
  environments      = ["dev", "prod"]

  enable_vault_integration = true
  vault_url                = "https://vault.example.com:8200"
  vault_namespace          = "admin"
}
```

## Security Model

This module implements HashiCorp's recommended security patterns:

1. **No static credentials** — workspaces auth to Vault via short-lived JWTs verified against the TFC OIDC endpoint
2. **Bound claims** — each role is locked to a specific org + project + workspace via the `sub` claim
3. **Input validation** — lifecycle preconditions guard team lookups and org access

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6.0 |
| tfe | >= 0.58.0, < 1.0.0 |
| vault | >= 4.0.0, < 6.0.0 |

## Prerequisites

- HCP Terraform or Terraform Enterprise organization
- API token with permission to create projects, workspaces, and variable sets
- Vault cluster with permission to manage JWT auth backends, policies, and namespaces

## License

[MPL-2.0](./LICENSE)

# Terraform Landing Zone Orchestrator

This repository is a **Thin Orchestration Layer** that automates application onboarding to **HCP Terraform** or **Terraform Enterprise**, with optional **Vault Enterprise** or **HCP Vault Dedicated** integration natively woven through separate, dedicated module repositories.

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

- **Decoupled Architecture** — Modules are natively segregated by focus (Workspace vs Vault vs Run-tasks)
- **Vault integration** — JWT-based workload identity federation with no static credentials stored in Terraform
- **Day 2 Enhancements** — Optional integrations with Checkov/Infracost (Run Tasks), Slack (Notifications), and Variable Sets seamlessly executed during workspace provisioning.
- **Dynamic OIDC Support** — Out-of-the-box support for `TFC_WORKLOAD_IDENTITY` via AWS/GCP/Azure without Vault overhead.

## Module Ecosystem Structure

This Orchestrator fetches configurations from external versioned repositories. Ensure the following Lego Block packages are available in your Registry or Git Server:

- `terraform-tfe-workspace`
- `terraform-vault-auth`
- `terraform-vault-namespace`
- `terraform-tfc-cloud-oidc`
- `terraform-tfc-run-tasks`
- `terraform-tfc-variable-sets`
- `terraform-tfc-notifications`

A specific "Day 2 App Deploy" module `terraform-vault-aws` is also provided in the wider ecosystem for applications needing dedicated AWS Secret mounts rather than base Workspace deployments.

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

1. **No static credentials** — Workspaces authenticate to Vault using short-lived JWT tokens verified against the Terraform platform's OIDC endpoint
2. **Bound claims** — Each role restricts authentication to a specific organization, project, and workspace using the `sub` claim
3. **Pre-condition Validation** — Critical inputs and lookups (like team names and organization accessibility) are strictly guarded using lifecycle preconditions internally.

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

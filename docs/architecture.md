# Architecture

Architecture, auth flow, and component boundaries for the landing zone.

## High-Level Design

The landing zone module follows a three-tier workspace hierarchy:

**Tier 1 — Bootstrap** (not managed by this module): An operator creates the
initial management workspace and provides it with an organization API token
and Vault credentials.

**Tier 2 — Management** (this module): The management workspace runs this
module to provision application-specific projects, workspaces, and Vault
resources. It acts as the "workspace vending machine."

**Tier 3 — Application** (provisioned by this module): Application teams use
these workspaces to deploy their infrastructure. Vault authentication happens
automatically via workload identity.

## Authentication Flow

```
 ┌─────────────────┐
 │ Application      │
 │ Workspace        │
 │ (Terraform Run)  │
 └────────┬─────────┘
          │
          │ 1. Workspace requests a JWT from HCP Terraform
          │    containing org, project, workspace, and run_phase claims
          ▼
 ┌─────────────────┐
 │ HCP Terraform   │
 │ OIDC Endpoint   │──── Public keys at /.well-known/openid-configuration
 └────────┬────────┘
          │
          │ 2. Workspace presents JWT to Vault
          ▼
 ┌─────────────────┐
 │ Vault JWT Auth   │
 │ Backend          │
 │                  │
 │ - Validates sig  │
 │ - Checks aud     │
 │ - Checks sub     │
 │   bound claims   │
 └────────┬────────┘
          │
          │ 3. Vault issues a scoped token with attached policies
          ▼
 ┌─────────────────┐
 │ Application      │
 │ Workspace        │
 │                  │
 │ Uses token to    │
 │ read/write       │
 │ secrets          │
 └─────────────────┘
```

## Submodule Composition

```
                    ┌───────────────────────┐
                    │     Root Module       │
                    │     (main.tf)         │
                    └───────────┬───────────┘
                                │
              ┌─────────────────┼─────────────────┐
              ▼                 ▼                  ▼
  ┌───────────────────┐ ┌────────────────┐ ┌────────────────────┐
  │ tfe-workspace     │ │ vault-auth     │ │ vault-namespace    │
  │                   │ │                │ │                    │
  │ - tfe_project     │ │ - jwt_backend  │ │ - vault_namespace  │
  │ - tfe_workspace   │ │ - jwt_role     │ │ - vault_mount (kv) │
  │ - tfe_variable    │ │ - vault_policy │ │                    │
  │ - tfe_team_access │ │                │ │                    │
  └───────────────────┘ └────────────────┘ └────────────────────┘
    Always created       count = enable_    count = enable_
                         vault_integration  vault_namespace
```

Each submodule can be used independently. For example, if you already have a
workspace provisioning pipeline and only need the Vault auth configuration,
reference `standalone-repos/terraform-vault-auth` directly.

## Feature Flag Resolution

Platform-specific behavior is resolved in `locals.tf`:

| Variable | HCP | Enterprise |
|----------|-----|-----------|
| `tfc_hostname` | `app.terraform.io` | User-provided |
| `oidc_discovery_url` | `https://app.terraform.io` | `https://tfe.example.com` |
| `vault_root_namespace` | `admin` | User-provided or empty |

This approach avoids code duplication. Resource definitions in the submodules
remain identical regardless of the target platform.

## Security Boundaries

- **Workspace isolation**: Each workspace can only authenticate as itself.
  Bound claims include the organization, project, and workspace name.
- **Namespace isolation**: When enabled, each application operates in its
  own Vault namespace with no visibility into sibling namespaces.
- **Token lifecycle**: Tokens are short-lived (20 min default), renewable
  by the Terraform runtime, and automatically revoked when the run completes.
- **Policy composition**: The base policy grants only token self-management.
  All secret access requires explicit additional policies.

# Getting Started

Example configuration for a TFC project with Vault JWT auth.

## Prerequisites

**Terraform Platform:**
- An HCP Terraform organization (or Terraform Enterprise instance)
- An organization-level API token (or team token with project-create permissions)

**Vault:**
- A running Vault cluster (HCP Vault Dedicated or Vault Enterprise)
- A token with permission to create auth backends, roles, and policies
- The cluster URL and the target namespace (typically `admin` for HCP Vault)

**Local Tooling:**
- Terraform CLI >= 1.6.0
- Access to the private module registry (if publishing there)

## Step 1: Create Your Configuration

Create a new directory for the landing zone configuration and add a `main.tf`:

```hcl
provider "tfe" {}

provider "vault" {
  address   = var.vault_url
  namespace = var.vault_namespace
}

module "app_landing_zone" {
  source  = "app.terraform.io/your-org/landing-zone/tfe"
  version = "~> 1.0"

  organization_name = "your-org"
  project_name      = "inventory-service-project"
  application_name  = "inventory-svc"
  environments      = ["dev", "staging", "prod"]

  enable_vault_integration = true
  vault_url                = var.vault_url
  vault_namespace          = var.vault_namespace
}
```

## Step 2: Set Environment Variables

```bash
export TFE_TOKEN="your-terraform-api-token"
export VAULT_ADDR="https://vault.example.com:8200"
export VAULT_TOKEN="your-vault-admin-token"
export VAULT_NAMESPACE="admin"
```

## Step 3: Initialize and Apply

```bash
terraform init
terraform plan
terraform apply
```

The module creates:
- A project called `inventory-service-project`
- Three workspaces: `inventory-svc-dev`, `inventory-svc-staging`, `inventory-svc-prod`
- A JWT auth backend in Vault (if not already present)
- One Vault role per workspace with bound claims
- Vault dynamic credential environment variables on each workspace

## Step 4: Connect Application Code

In your application infrastructure repository, configure the Vault provider
with an empty block. HCP Terraform injects the credentials at runtime:

```hcl
provider "vault" {}

data "vault_kv_secret_v2" "db_creds" {
  mount = "secret"
  name  = "inventory-svc/database"
}
```

## Step 5: Verify

Navigate to your Terraform platform UI. Open the new project and confirm that
each workspace shows `TFC_VAULT_PROVIDER_AUTH = true` in its environment
variables. Trigger a plan on any workspace — you should see Vault
authentication succeed in the run logs.

## Next Steps

- Set `enable_vault_namespace = true` for a dedicated app namespace
- Add custom Vault policies for your secret paths
- Use `enable_plan_apply_separation = true` in prod for least-privilege
- Sentinel policy sets can be attached via `enable_sentinel_policies`
- See the [complete example](../examples/complete/) for all options

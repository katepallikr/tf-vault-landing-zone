# Copilot instructions for this repository

## What this module does
- This is a Terraform landing-zone module that provisions **TFE/HCP Terraform** projects + workspaces and optional **Vault** auth/namespace resources.
- Root module orchestration is in [main.tf](../main.tf), with platform/claim computation in [locals.tf](../locals.tf).
- Submodule boundaries are strict:
  - [standalone-repos/terraform-tfe-workspace/main.tf](../standalone-repos/terraform-tfe-workspace/main.tf): `tfe_project`, `tfe_workspace`, workspace vars, team access, run triggers, Sentinel attachments.
  - [standalone-repos/terraform-vault-auth/main.tf](../standalone-repos/terraform-vault-auth/main.tf): JWT backend, Vault policies, JWT auth roles.
  - [standalone-repos/terraform-vault-namespace/main.tf](../standalone-repos/terraform-vault-namespace/main.tf): optional namespace + KV v2 mount.

## Core architecture patterns
- Treat `locals.tf` as the single source of platform logic (`platform_type`, hostname resolution, namespace pathing, role maps).
- Workspace and role naming is convention-based: `<application>-<environment>` and `<application>-tfc-<environment>` from [locals.tf](../locals.tf).
- Optional behavior is enabled with `count`/conditional `for_each` (e.g., Vault modules and Vault env vars), not separate code paths.
- Plan/apply separation is implemented end-to-end: role claims in [locals.tf](../locals.tf), role resources in [standalone-repos/terraform-vault-auth/main.tf](../standalone-repos/terraform-vault-auth/main.tf), and workspace env vars in [standalone-repos/terraform-tfe-workspace/main.tf](../standalone-repos/terraform-tfe-workspace/main.tf).

## Developer workflows (match CI)
- Local validation sequence should mirror CI in [.github/workflows/ci.yml](workflows/ci.yml):
  1. `terraform fmt -check -recursive -diff`
  2. `tflint --init && tflint -f compact --recursive`
  3. `terraform init -backend=false && terraform validate`
  4. `terraform test` (or `terraform test -verbose`)
- Tests are native `.tftest.hcl` with `mock_provider` and **no real infrastructure**: see [tests/basic.tftest.hcl](../tests/basic.tftest.hcl), [tests/feature_flags.tftest.hcl](../tests/feature_flags.tftest.hcl), [tests/validation.tftest.hcl](../tests/validation.tftest.hcl).
- Pre-commit hooks are authoritative for local quality gates: [.pre-commit-config.yaml](../.pre-commit-config.yaml).

## Repo-specific coding conventions
- Keep identifiers `snake_case`; include descriptions and validations on inputs (pattern in [variables.tf](../variables.tf)).
  - Prefer map-driven expansion (`for_each`, `setproduct`) over repeated resources (pattern in [standalone-repos/terraform-tfe-workspace/main.tf](../standalone-repos/terraform-tfe-workspace/main.tf)).
- Use `null` assignment to omit optional provider args (e.g., namespace, working directory) instead of empty strings.
- Preserve comment-header structure by concern blocks (Platform, Workspace, Vault, Sentinel, etc.).

## Integration details that must stay consistent
- JWT/OIDC trust chain must align: `tfc_hostname` → issuer/discovery URL → Vault JWT backend (`oidc_discovery_url`, `bound_issuer`) in [standalone-repos/terraform-vault-auth/main.tf](../standalone-repos/terraform-vault-auth/main.tf).
- `bound_claims.sub` format is a compatibility contract with TFC run identity (`organization:...:project:...:workspace:...:run_phase:...`) from [locals.tf](../locals.tf).
- Workspace Vault env vars (`TFC_VAULT_*`) in [standalone-repos/terraform-tfe-workspace/main.tf](../standalone-repos/terraform-tfe-workspace/main.tf) must match created Vault roles and auth path.
- Docs are auto-injected (`<!-- BEGIN_TF_DOCS -->`) via terraform-docs config in [.terraform-docs.yml](../.terraform-docs.yml); do not hand-edit generated sections in READMEs.

## Change guidance for agents
- For new features, update root inputs in [variables.tf](../variables.tf), derive behavior in [locals.tf](../locals.tf), wire in [main.tf](../main.tf), then touch only affected submodule(s).
- Keep examples aligned with behavior, especially [examples/basic/main.tf](../examples/basic/main.tf) and [examples/complete/main.tf](../examples/complete/main.tf).
- If a change affects validation or feature flags, add/update `.tftest.hcl` coverage in [tests/](../tests/).

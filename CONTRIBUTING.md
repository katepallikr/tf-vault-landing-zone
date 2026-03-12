# Contributing

Thank you for considering a contribution to this module. This guide covers
everything you need to get started.

## Development Setup

### Prerequisites

- Terraform >= 1.6.0
- TFLint
- pre-commit
- terraform-docs

### Getting Started

```bash
git clone <repository-url>
cd terraform-tfe-landing-zone
pre-commit install
pre-commit install --hook-type commit-msg
```

## Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/).
The release pipeline reads commit types to determine version bumps.

| Type | Version Bump | Example |
|------|-------------|---------|
| `feat` | Minor | `feat: add sentinel policy attachment` |
| `fix` | Patch | `fix: correct vault namespace resolution for HCP` |
| `docs` | None | `docs: update getting-started guide` |
| `BREAKING CHANGE` | Major | `feat!: rename vault_url to vault_address` |

## Testing

Run all tests locally before pushing:

```bash
terraform init -backend=false
terraform test
terraform test -verbose  # for debugging
```

Tests use mock providers and require no external infrastructure.

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes with appropriate tests
3. Run `pre-commit run --all-files`
4. Push and open a pull request
5. Ensure all CI checks pass
6. Request review from the appropriate CODEOWNERS

## Code Style

Follow the [HashiCorp Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style):

- Use `snake_case` for all identifiers
- Add descriptions to every variable and output
- Group related resources with comment headers
- Keep modules focused on a single responsibility

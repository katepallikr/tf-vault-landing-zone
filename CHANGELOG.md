# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.0] - Unreleased

### Added

- Initial release of the landing zone module
- Workspace submodule with project, workspace, and variable set management
- Vault auth submodule with JWT backend, role, and policy management
- Vault namespace submodule with KV v2 secrets engine
- Feature flags for HCP vs. Enterprise platform variants
- Plan/apply role separation for least-privilege access
- Composable Vault policy library (reader, writer, namespace-admin)
- Native Terraform tests with mock providers
- GitHub Actions CI/CD pipeline with semantic release
- Examples: basic, complete, and enterprise configurations
- Full documentation with architecture diagrams

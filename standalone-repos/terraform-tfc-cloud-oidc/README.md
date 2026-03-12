# Terraform TFC Cloud OIDC Module

This standalone module is responsible for configuring Dynamic Provider Credentials bridging Terraform Enterprise into Cloud service providers like AWS, Azure, and GCP.

It generates the required `TFC_WORKLOAD_IDENTITY_*` variables automatically for provisioned Workspaces.

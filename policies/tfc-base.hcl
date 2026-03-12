# Terraform Workspace Base Policy
#
# Every workspace that authenticates to Vault via workload identity
# must have these capabilities. Without them, dynamic credential
# sessions will fail to initialize or clean up properly.

path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

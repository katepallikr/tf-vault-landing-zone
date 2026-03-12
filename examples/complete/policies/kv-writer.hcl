path "secret/data/payments-api/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "secret/metadata/payments-api/*" {
  capabilities = ["read", "list", "delete"]
}

path "secret/delete/payments-api/*" {
  capabilities = ["update"]
}

path "secret/undelete/payments-api/*" {
  capabilities = ["update"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

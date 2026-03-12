path "secret/data/payments-api/*" {
  capabilities = ["read"]
}

path "secret/metadata/payments-api/*" {
  capabilities = ["read", "list"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

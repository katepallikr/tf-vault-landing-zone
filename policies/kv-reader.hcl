# Read/list access for KV secrets.

path "secret/data/{{identity.entity.name}}/*" {
  capabilities = ["read"]
}

path "secret/metadata/{{identity.entity.name}}/*" {
  capabilities = ["read", "list"]
}

path "secret/metadata/" {
  capabilities = ["list"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

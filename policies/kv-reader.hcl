# KV v2 Read-Only Policy
#
# Grants read and list access to secrets under the specified path.
# Attach this to workspace roles that only need to consume secrets.

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

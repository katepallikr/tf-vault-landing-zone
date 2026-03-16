# Full CRUD access to secrets. Includes soft-delete/undelete.

path "secret/data/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "secret/metadata/{{identity.entity.name}}/*" {
  capabilities = ["read", "list", "delete"]
}

path "secret/delete/{{identity.entity.name}}/*" {
  capabilities = ["update"]
}

path "secret/undelete/{{identity.entity.name}}/*" {
  capabilities = ["update"]
}

path "secret/destroy/{{identity.entity.name}}/*" {
  capabilities = ["update"]
}

path "secret/metadata/" {
  capabilities = ["list"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

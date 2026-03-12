# Namespace Administrator Policy
#
# Grants full administrative access within a namespace.
# Does not grant access to parent or sibling namespaces.

path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/policies/acl" {
  capabilities = ["list"]
}

path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

path "sys/auth" {
  capabilities = ["read"]
}

path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/leases/*" {
  capabilities = ["read", "update", "list"]
}

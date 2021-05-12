# Terraform managed product policy
# DO NOT EDIT manually, changes won't be persisted


path "${product}/${environment}/*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}
# Terraform managed product policy
# DO NOT EDIT manually, changes won't be persisted

##
# Authentication admin that can 
##

path "auth/${product}/${environment}/approle/role/{{identity.entity.meta.approle}}*" {
  capabilities = ["create", "update", "read", "list"]
}

path "auth/${product}/${environment}/approle/role/{{identity.entity.meta.role}}*" {
  capabilities = ["create", "update", "read", "list"]
}
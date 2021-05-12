# Terraform managed product policy
# DO NOT EDIT manually, changes won't be persisted

##
# KV Secrets - Service Individual
##

path "${product}/${environment}/kv/data/{{identity.entity.metadata.approle}}/*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}

path "${product}/${environment}/*" {
  capabilities = ["list"]
}

##
# KV Secrets - Common Section
##

path "${product}/${environment}/kv/data/common/*" {
  capabilities = ["read", "list"]
}

path "${product}/${environment}/kv/data/common/{{identity.entity.metadata.approle}}/*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}

path "${product}/${environment}/kv/common/*" {
  capabilities = ["list", "read"]
}


##
# Transit secret engine rules
##

path "${product}/${environment}/transit/+/{{identity.entity.metadata.approle}}" {
  capabilities = ["create", "update", "read", "delete"]
}
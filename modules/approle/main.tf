locals {
  name = "${var.meta.product}__${var.meta.environment}__${var.approle}"
  approle_meta = {
    environment = var.meta.environment
    product     = var.meta.product
    approle     = var.approle
  }
  meta = merge(var.meta, local.approle_meta)
}

resource "vault_approle_auth_backend_role" "backend_role" {
  backend   = var.approle_backend
  role_name = local.meta.approle
}

resource "vault_identity_entity" "identity_entity" {
  name     = local.name
  policies = concat(var.policies, [local.name])
  metadata = local.meta
}

resource "vault_identity_entity_alias" "alias" {
  name           = vault_approle_auth_backend_role.backend_role.role_id
  mount_accessor = var.accessor
  canonical_id   = vault_identity_entity.identity_entity.id
}
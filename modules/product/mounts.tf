locals {
  approle_backend = "${var.meta.product}/${var.meta.environment}/approle"
}

resource "vault_auth_backend" "approle" {
  path = local.approle_backend
  type = "approle"
}

resource "vault_mount" "kv" {
  path                      = "${var.meta.product}/${var.meta.environment}/kv"
  type                      = "kv-v2"
  description               = "KV ${var.meta.product}"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_mount" "transit" {
  path                      = "${var.meta.product}/${var.meta.environment}/transit"
  type                      = "transit"
  description               = "Transit ${var.meta.product}"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}
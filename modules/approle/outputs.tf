output "outputs" {
  value = {
    role_id   = vault_approle_auth_backend_role.backend_role.role_id
    entity_id = vault_identity_entity.identity_entity.id
    approle   = local.meta.approle
  }
}

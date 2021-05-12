output "outputs" {
  value = {
    product           = var.meta.product
    approle_accessor  = vault_auth_backend.approle.accessor
    approle_backend   = local.approle_backend
    policy_app        = vault_policy.policy_app.name
    policy_admin      = vault_policy.policy_admin.name
    policy_kubernetes = vault_policy.policy_kubernetes.name
  }
}

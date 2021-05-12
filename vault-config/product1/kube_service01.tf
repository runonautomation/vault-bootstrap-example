resource "kubernetes_service_account" "service01" {
  metadata {
    name      = local.settings.service01
    namespace = local.meta.kube_namespace
  }
}

data "kubernetes_service_account" "service01" {
  depends_on = ["kubernetes_service_account.service01"]
  metadata {
    name      = local.settings.service01
    namespace = local.meta.kube_namespace
  }
}

resource "vault_kubernetes_auth_backend_role" "service01" {
  backend                          = var.kubernetes_backend
  role_name                        = local.settings.service01
  bound_service_account_names      = [local.settings.service01]
  bound_service_account_namespaces = [local.meta.kube_namespace]
  token_ttl                        = 3600
  token_policies                   = [module.product.outputs.policy_kubernetes]
}

resource "vault_identity_entity_alias" "service01" {
  name           = data.kubernetes_service_account.service01.metadata[0].uid
  mount_accessor = var.kubernetes_backend_accessor
  canonical_id   = module.service01.outputs.entity_id
}
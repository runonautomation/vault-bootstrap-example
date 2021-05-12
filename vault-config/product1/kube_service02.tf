resource "kubernetes_service_account" "service02" {
  metadata {
    name      = local.settings.service02
    namespace = local.meta.kube_namespace
  }
}

data "kubernetes_service_account" "service02" {
  depends_on = ["kubernetes_service_account.service02"]
  metadata {
    name      = local.settings.service02
    namespace = local.meta.kube_namespace
  }
}

resource "vault_kubernetes_auth_backend_role" "service02" {
  backend                          = var.kubernetes_backend
  role_name                        = local.settings.service02
  bound_service_account_names      = [local.settings.service02]
  bound_service_account_namespaces = [local.meta.kube_namespace]
  token_ttl                        = 3600
  token_policies                   = [module.product.outputs.policy_kubernetes]
}

resource "vault_identity_entity_alias" "service02" {
  name           = data.kubernetes_service_account.service02.metadata[0].uid
  mount_accessor = var.kubernetes_backend_accessor
  canonical_id   = module.service02.outputs.entity_id
}
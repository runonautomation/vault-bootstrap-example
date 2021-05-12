resource "kubernetes_service_account" "vault-prod" {
  provider = kubernetes.prod
  metadata {
    name      = "vault-prod"
    namespace = "prod"
  }
}

resource "kubernetes_cluster_role_binding" "vault-prod" {
  provider = kubernetes.prod
  metadata {
    name = "vault-prod"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vault-prod"
    namespace = "prod"
  }
}

resource "kubernetes_namespace" "prod" {
  provider = kubernetes.prod
  metadata {
    name = "prod"
  }
}

resource "vault_auth_backend" "kube_prod" {
  type = "kubernetes"
  path = "kube_prod"
}
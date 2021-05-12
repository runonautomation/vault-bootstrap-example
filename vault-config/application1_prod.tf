module "application01_prod" {
  environment                 = "prod"
  source                      = "./product1"
  kubernetes_backend          = vault_auth_backend.kube_prod.path
  kubernetes_backend_accessor = vault_auth_backend.kube_prod.accessor
  providers = {
    kubernetes = kubernetes.prod
  }
}
locals {
  meta = {
    environment    = var.environment
    product        = "product1"
    kube_namespace = var.environment
  }
  settings = {
    approle_accessor = module.product.outputs.approle_accessor
    approle_backend  = module.product.outputs.approle_backend
    service01        = "service01"
    service02        = "service02"
  }
}

module "product" {
  source = "../../modules/product"
  meta   = local.meta
}

module "service01" {
  source          = "../../modules/approle"
  meta            = local.meta
  accessor        = module.product.outputs.approle_accessor
  approle_backend = module.product.outputs.approle_backend
  approle         = local.settings.service01
  policies        = [module.product.outputs.policy_app]
}

module "service02" {
  source          = "../../modules/approle"
  meta            = local.meta
  accessor        = module.product.outputs.approle_accessor
  approle_backend = module.product.outputs.approle_backend
  approle         = local.settings.service02
  policies        = [module.product.outputs.policy_app]
}

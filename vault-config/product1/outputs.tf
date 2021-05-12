
output "outputs" {
  value = {
    meta      = local.meta
    settings  = local.settings
    product   = module.product.outputs
    service01 = module.service01.outputs
    service02 = module.service02.outputs
  }
}

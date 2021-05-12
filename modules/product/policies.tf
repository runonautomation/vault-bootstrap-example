locals {
  policy_app        = "${var.meta.product}__${var.meta.environment}__srv"
  policy_kubernetes = "${var.meta.product}__${var.meta.environment}__k8s"
  policy_admin      = "${var.meta.product}__${var.meta.environment}__admin"
}

data "template_file" "policy_app" {
  template = file("${path.module}/policy_app.hcl.tpl")
  vars = {
    environment = var.meta.environment
    product     = var.meta.product
  }
}

resource "vault_policy" "policy_app" {
  name   = local.policy_app
  policy = data.template_file.policy_app.rendered
}

data "template_file" "policy_kubernetes" {
  template = file("${path.module}/policy_kubernetes.hcl.tpl")
  vars = {
    environment = var.meta.environment
    product     = var.meta.product
  }
}

resource "vault_policy" "policy_kubernetes" {
  name   = local.policy_kubernetes
  policy = data.template_file.policy_kubernetes.rendered
}

data "template_file" "policy_admin" {
  template = file("${path.module}/policy_admin.hcl.tpl")
  vars = {
    environment = var.meta.environment
    product     = var.meta.product
  }
}

resource "vault_policy" "policy_admin" {
  name   = local.policy_admin
  policy = data.template_file.policy_admin.rendered
}
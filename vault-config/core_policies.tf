resource "vault_policy" "root_policy" {
  name   = "root_policy"
  policy = file("${path.module}/policies/root.hcl")
}

resource "vault_policy" "audit" {
  name   = "audit"
  policy = file("${path.module}/policies/audit.hcl")
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("${path.module}/policies/admin.hcl")
}

resource "vault_policy" "ops" {
  name   = "ops"
  policy = file("${path.module}/policies/ops.hcl")
}
provider "vault" {}

provider "kubernetes" {
  alias       = "prod"
  config_path = "~/.kube/config"
}
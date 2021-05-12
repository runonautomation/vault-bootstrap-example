variable "project_id" {}

resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  project            = var.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "primary" {
  project                  = var.project_id
  name                     = "k8s"
  location                 = "europe-west1-b"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  project    = var.project_id
  name       = "np1"
  location   = "europe-west1-b"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  node_config {
    preemptible     = true
    machine_type    = "e2-medium"
    service_account = google_service_account.gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_service_account" "gke" {
  project      = var.project_id
  account_id   = "gke-sa"
  display_name = "GKE SA"
}
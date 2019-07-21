terraform {
  required_version = ">= 0.12.4"
  required_providers {
    google = ">= 2.11"
  }
}

data "google_container_engine_versions" "zone" {
  location       = var.zone
  version_prefix = "$(var.k8s_minor_version}."
}

resource "google_container_cluster" "cluster" {
  project  = var.project
  name     = var.cluster_name
  location = var.zone

  min_master_version = data.google_container_engine_versions.zone.latest_master_version

  resource_labels = var.resource_labels

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "preempt" {
  project    = google_container_cluster.cluster.project
  cluster    = google_container_cluster.cluster.name
  name       = "preempt"
  location   = google_container_cluster.cluster.location
  version    = data.google_container_engine_versions.zone.latest_node_version
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.node_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    # TODO understand this better
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

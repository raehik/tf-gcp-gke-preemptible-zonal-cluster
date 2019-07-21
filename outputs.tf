output "master_version" {
  value = google_container_cluster.cluster.master_version
}

output "node_version" {
  value = google_container_node_pool.preempt.version
}

output "gcloud_kubeconfig_cmd" {
  value = "gcloud --project ${google_container_cluster.cluster.project} container clusters get-credentials ${google_container_cluster.cluster.name} --zone ${google_container_cluster.cluster.zone}"
}

output "latest_node_version" {
  value = data.google_container_engine_versions.zone.latest_node_version
}

output "latest_master_version" {
  value = data.google_container_engine_versions.zone.latest_master_version
}

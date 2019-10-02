variable "project" {
  type = string
}
variable "zone" {
  type = string
}
variable "k8s_minor_version" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "resource_labels" {
  type = map(string)
}

variable "node_machine_type" {
  type = string
}
variable "node_count" {
  type = number
}
variable "node_disk_size_gb" {
  type = number
}

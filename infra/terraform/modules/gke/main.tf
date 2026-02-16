resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network_name
  subnetwork = var.subnet_name

  # Enabling Autopilot for easier management, or Standard.
  # Using Standard here for explicit node pool control if needed later,
  # but enabling simple configuration.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project    = var.project_id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

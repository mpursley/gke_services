resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for Python Apps"
  format        = "DOCKER"
  project       = var.project_id
}

output "repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

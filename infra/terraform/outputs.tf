output "cluster_endpoint" {
  value     = module.gke.cluster_endpoint
  sensitive = true
}

output "repository_url" {
  value = module.artifact_registry.repository_url
}

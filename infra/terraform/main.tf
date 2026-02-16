module "vpc" {
  source       = "./modules/vpc"
  project_id   = var.project_id
  region       = var.region
  network_name = "k8s-network"
}

module "artifact_registry" {
  source        = "./modules/artifact_registry"
  project_id    = var.project_id
  region        = var.region
  repository_id = "app-repo"
}

module "gke" {
  source       = "./modules/gke"
  project_id   = var.project_id
  region       = var.region
  network_name = module.vpc.network_name
  subnet_name  = module.vpc.subnet_name
  cluster_name = "main-cluster"
}

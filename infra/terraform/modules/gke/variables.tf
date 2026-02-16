variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
}

variable "network_name" {
  description = "The VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "The VPC subnet name"
  type        = string
}

variable "cluster_name" {
  description = "The name of the K8s cluster"
  type        = string
  default     = "main-cluster"
}

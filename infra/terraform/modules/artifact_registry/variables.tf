variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
}

variable "repository_id" {
  description = "The name of the Artifact Registry repository"
  type        = string
  default     = "app-repo"
}

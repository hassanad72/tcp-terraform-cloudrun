variable "project_id" {
  description = "GCP project where GitHub Workload Identity is configured."
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the bucket containing Terraform state."
  type        = string
}

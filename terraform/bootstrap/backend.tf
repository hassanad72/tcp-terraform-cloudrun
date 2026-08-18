terraform {
  backend "gcs" {
    bucket = "gcp-terraform-ai-ps"
    prefix = "bootstrap/github-actions"
  }
}
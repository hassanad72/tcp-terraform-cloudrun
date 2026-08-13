terraform {
  backend "gcs" {
    bucket = "gcp-terraform-ai-ps"
    prefix = "environment/dev"
  }
}
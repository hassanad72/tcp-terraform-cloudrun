variable "project_id" {
  description = "ID of the GCP project where APIs are enabled."
  type        = string
}

variable "services" {
  description = "Google Cloud APIs to enable."
  type        = set(string)

  validation {
    condition = alltrue([
      for service in var.services :
      endswith(service, ".googleapis.com")
    ])

    error_message = "Every service must be a valid Google API name ending in .googleapis.com."
  }
}

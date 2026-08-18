variable "project_id" {
  description = "GCP project containing the GitHub Workload Identity resources."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to authenticate, in owner/repository format."
  type        = string

  validation {
    condition = can(regex(
      "^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$",
      var.github_repository
    ))
    error_message = "github_repository must use the owner/repository format."
  }
}

variable "project_roles" {
  description = "Project-level IAM roles granted to the Terraform CI service account."
  type        = set(string)
  default     = []

  validation {
    condition = alltrue([
      for role in var.project_roles : startswith(role, "roles/")
    ])
    error_message = "Each project role must be a predefined role beginning with roles/."
  }
}

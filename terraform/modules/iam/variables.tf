variable "project_id" {
  description = "ID of the GCP project where service accounts and project IAM grants are created."
  type        = string
}

variable "service_accounts" {
  description = "Service accounts keyed by a stable Terraform identifier."

  type = map(object({
    name        = string
    account_id  = string
    description = optional(string)
  }))

  validation {
    condition = alltrue([
      for service_account in values(var.service_accounts) :
      length(service_account.account_id) >= 6 &&
      length(service_account.account_id) <= 30 &&
      can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", service_account.account_id))
    ])
    error_message = "Each service account account_id must be 6-30 characters, start with a lowercase letter, end with a lowercase letter or number, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "iam_role" {
  description = "Project IAM role grants keyed by a stable Terraform identifier."

  type = map(object({
    role                = string
    service_account_key = string
  }))
}

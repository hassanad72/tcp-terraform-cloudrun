variable "buckets" {
  type = map(object({
    name               = string
    location           = string
    storage_class      = optional(string, "STANDARD")
    force_destroy      = optional(bool, false)
    versioning_enabled = optional(bool, true)
    labels             = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for bucket in var.buckets :
      contains([
        "STANDARD",
        "NEARLINE",
        "COLDLINE",
        "ARCHIVE",
      ], bucket.storage_class)
    ])

    error_message = "storage_class must be STANDARD, NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "project_id" {
  type = string
}
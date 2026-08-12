variable "project_id" {
  type = string

}

variable "location" {
  type = string
}

variable "repo" {
  type = map(object({
    repository_id = string
    description   = string
    format        = string
    labels        = optional(map(string), {})

    immutable_tags = optional(bool, false)
  }))
}

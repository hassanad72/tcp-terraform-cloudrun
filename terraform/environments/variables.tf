variable "project_id" {
  description = "ID of the GCP project used by this environment."
  type        = string
}

variable "region" {
  description = "Default GCP region used by this environment."
  type        = string
}

variable "services" {
  description = "Google Cloud APIs enabled for this environment."
  type        = set(string)
}

variable "vpc_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "routing_mode" {
  description = "Network-wide routing mode."
  type        = string
  default     = "REGIONAL"
}

variable "subnets" {
  description = "Subnets created in the VPC."

  type = map(object({
    name                  = string
    region                = string
    cidr                  = string
    private_google_access = optional(bool, true)
    flow_logs_enabled     = optional(bool, true)
    flow_logs_aggregation = optional(string, "INTERVAL_5_SEC")
    flow_logs_sampling    = optional(number, 0.5)
    flow_logs_metadata    = optional(string, "INCLUDE_ALL_METADATA")
  }))
}

variable "firewall_rules" {
  description = "Firewall rules created in the environment VPC."

  type = map(object({
    name        = string
    description = optional(string)
    direction   = string
    priority    = optional(number, 1000)
    disabled    = optional(bool, false)

    source_ranges      = optional(list(string), [])
    destination_ranges = optional(list(string), [])
    source_tags        = optional(list(string), [])
    target_tags        = optional(list(string), [])

    source_service_accounts = optional(list(string), [])
    target_service_accounts = optional(list(string), [])

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])

    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])

    log_config = optional(object({
      metadata = optional(string, "INCLUDE_ALL_METADATA")
    }))
  }))
}

variable "service_accounts" {
  description = "Service accounts created for this environment."

  type = map(object({
    name        = string
    account_id  = string
    description = optional(string)
  }))
}

variable "iam_role" {
  description = "Project IAM roles granted to environment service accounts."

  type = map(object({
    role                = string
    service_account_key = string
  }))

  default = {}
}

variable "service_name" {
  type = string
}



variable "min_instances" {
  type = number
}

variable "max_instances" {
  type = number
}

variable "image" {
  type = string
}


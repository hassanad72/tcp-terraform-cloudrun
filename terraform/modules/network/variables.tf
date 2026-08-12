variable "vpc_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "routing_mode" {
  description = "Network-wide routing mode."
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.routing_mode)
    error_message = "routing_mode must be either GLOBAL or REGIONAL."
  }
}

variable "subnets" {
  description = "Subnets keyed by a stable Terraform identifier."

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

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) : can(cidrhost(subnet.cidr, 0))
    ])
    error_message = "Each subnet cidr must be a valid CIDR block."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) : contains([
        "INTERVAL_5_SEC",
        "INTERVAL_30_SEC",
        "INTERVAL_1_MIN",
        "INTERVAL_5_MIN",
        "INTERVAL_10_MIN",
        "INTERVAL_15_MIN",
      ], subnet.flow_logs_aggregation)
    ])
    error_message = "flow_logs_aggregation must be a supported VPC flow-log aggregation interval."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      subnet.flow_logs_sampling >= 0 && subnet.flow_logs_sampling <= 1
    ])
    error_message = "flow_logs_sampling must be between 0 and 1."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) : contains(
        ["EXCLUDE_ALL_METADATA", "INCLUDE_ALL_METADATA"],
        subnet.flow_logs_metadata
      )
    ])
    error_message = "flow_logs_metadata must be either EXCLUDE_ALL_METADATA or INCLUDE_ALL_METADATA."
  }
}

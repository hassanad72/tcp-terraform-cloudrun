variable "network_name" {
  description = "Name, ID, or self-link of the VPC network where firewall rules are created."
  type        = string
}

variable "firewall_rules" {
  description = "Firewall rules keyed by a stable Terraform identifier."

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

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      contains(["INGRESS", "EGRESS"], rule.direction)
    ])
    error_message = "Each firewall rule direction must be either INGRESS or EGRESS."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      rule.priority >= 0 && rule.priority <= 65535
    ])
    error_message = "Each firewall rule priority must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      (length(rule.allow) > 0) != (length(rule.deny) > 0)
    ])
    error_message = "Each firewall rule must define exactly one of allow or deny."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      rule.direction != "INGRESS" || length(rule.destination_ranges) == 0
    ])
    error_message = "INGRESS firewall rules cannot define destination_ranges."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      rule.direction != "EGRESS" || (
        length(rule.source_ranges) == 0 &&
        length(rule.source_tags) == 0 &&
        length(rule.source_service_accounts) == 0
      )
    ])
    error_message = "EGRESS firewall rules cannot define source_ranges, source_tags, or source_service_accounts."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      length(rule.source_tags) == 0 || length(rule.source_service_accounts) == 0
    ])
    error_message = "A firewall rule cannot combine source_tags with source_service_accounts."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      length(rule.target_tags) == 0 || length(rule.target_service_accounts) == 0
    ])
    error_message = "A firewall rule cannot combine target_tags with target_service_accounts."
  }

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      rule.log_config == null ? true : contains(
        ["EXCLUDE_ALL_METADATA", "INCLUDE_ALL_METADATA"],
        rule.log_config.metadata
      )
    ])
    error_message = "log_config.metadata must be either EXCLUDE_ALL_METADATA or INCLUDE_ALL_METADATA."
  }
}

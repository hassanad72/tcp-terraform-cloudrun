resource "google_compute_firewall" "firewall" {
  for_each = var.firewall_rules

  name        = each.value.name
  network     = var.network_name
  description = each.value.description
  direction   = each.value.direction
  priority    = each.value.priority
  disabled    = each.value.disabled

  source_ranges      = length(each.value.source_ranges) > 0 ? each.value.source_ranges : null
  destination_ranges = length(each.value.destination_ranges) > 0 ? each.value.destination_ranges : null
  source_tags        = length(each.value.source_tags) > 0 ? each.value.source_tags : null
  target_tags        = length(each.value.target_tags) > 0 ? each.value.target_tags : null

  source_service_accounts = length(each.value.source_service_accounts) > 0 ? each.value.source_service_accounts : null
  target_service_accounts = length(each.value.target_service_accounts) > 0 ? each.value.target_service_accounts : null

  dynamic "allow" {
    for_each = each.value.allow

    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny

    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  dynamic "log_config" {
    for_each = each.value.log_config == null ? [] : [each.value.log_config]

    content {
      metadata = log_config.value.metadata
    }
  }
}

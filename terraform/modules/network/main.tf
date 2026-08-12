resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets

  name          = each.value.name
  region        = each.value.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = each.value.cidr

  private_ip_google_access = each.value.private_google_access

  dynamic "log_config" {
    for_each = each.value.flow_logs_enabled ? [1] : []

    content {
      aggregation_interval = each.value.flow_logs_aggregation
      flow_sampling        = each.value.flow_logs_sampling
      metadata             = each.value.flow_logs_metadata
    }
  }
}

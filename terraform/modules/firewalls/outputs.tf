output "firewall_rule_ids" {
  description = "Firewall rule IDs keyed by the input map keys."
  value = {
    for key, rule in google_compute_firewall.firewall : key => rule.id
  }
}

output "firewall_rule_names" {
  description = "Firewall rule names keyed by the input map keys."
  value = {
    for key, rule in google_compute_firewall.firewall : key => rule.name
  }
}

output "firewall_rule_self_links" {
  description = "Firewall rule self-links keyed by the input map keys."
  value = {
    for key, rule in google_compute_firewall.firewall : key => rule.self_link
  }
}

output "vpc_id" {
  description = "ID of the VPC network."
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Name of the VPC network."
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "Self-link of the VPC network."
  value       = google_compute_network.vpc.self_link
}

output "subnet_ids" {
  description = "Subnet IDs keyed by the input map keys."
  value = {
    for key, subnet in google_compute_subnetwork.subnet : key => subnet.id
  }
}

output "subnet_names" {
  description = "Subnet names keyed by the input map keys."
  value = {
    for key, subnet in google_compute_subnetwork.subnet : key => subnet.name
  }
}

output "subnet_self_links" {
  description = "Subnet self-links keyed by the input map keys."
  value = {
    for key, subnet in google_compute_subnetwork.subnet : key => subnet.self_link
  }
}

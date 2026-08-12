output "enabled_services" {
  description = "Google Cloud APIs managed in the dev environment."
  value       = module.project_services.enabled_services
}

output "vpc_id" {
  description = "ID of the dev VPC network."
  value       = module.network.vpc_id
}

output "vpc_name" {
  description = "Name of the dev VPC network."
  value       = module.network.vpc_name
}

output "subnet_ids" {
  description = "Dev subnet IDs keyed by their input map keys."
  value       = module.network.subnet_ids
}

output "firewall_rule_ids" {
  description = "Dev firewall rule IDs keyed by their input map keys."
  value       = module.firewalls.firewall_rule_ids
}

output "firewall_rule_names" {
  description = "Dev firewall rule names keyed by their input map keys."
  value       = module.firewalls.firewall_rule_names
}

output "service_account_emails" {
  description = "Dev service account email addresses keyed by their input map keys."
  value       = module.iam.service_account_emails
}

output "service_account_members" {
  description = "Dev service account IAM member strings keyed by their input map keys."
  value       = module.iam.service_account_members
}

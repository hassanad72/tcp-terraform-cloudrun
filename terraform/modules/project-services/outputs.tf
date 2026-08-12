output "enabled_services" {
  description = "Google Cloud APIs managed by this module."
  value       = sort(keys(google_project_service.service))
}

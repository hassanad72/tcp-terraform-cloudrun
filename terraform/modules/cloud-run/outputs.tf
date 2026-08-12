output "service_id" {
  description = "ID of the Cloud Run service."
  value       = google_cloud_run_v2_service.cloud_run.id
}

output "service_name" {
  description = "Name of the Cloud Run service."
  value       = google_cloud_run_v2_service.cloud_run.name
}

output "service_uri" {
  description = "URI of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.cloud_run.uri
}

output "latest_created_revision" {
  description = "Name of the latest revision created for the Cloud Run service."
  value       = google_cloud_run_v2_service.cloud_run.latest_created_revision
}

output "latest_ready_revision" {
  description = "Name of the latest revision ready to serve traffic."
  value       = google_cloud_run_v2_service.cloud_run.latest_ready_revision
}

output "repository_ids" {
  description = "Artifact Registry repository IDs keyed by the input map keys."
  value = {
    for key, repository in google_artifact_registry_repository.artificat-repo :
    key => repository.id
  }
}

output "repository_names" {
  description = "Artifact Registry repository names keyed by the input map keys."
  value = {
    for key, repository in google_artifact_registry_repository.artificat-repo :
    key => repository.name
  }
}

output "repository_locations" {
  description = "Artifact Registry repository locations keyed by the input map keys."
  value = {
    for key, repository in google_artifact_registry_repository.artificat-repo :
    key => repository.location
  }
}

output "repository_formats" {
  description = "Artifact Registry repository formats keyed by the input map keys."
  value = {
    for key, repository in google_artifact_registry_repository.artificat-repo :
    key => repository.format
  }
}

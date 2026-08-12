resource "google_artifact_registry_repository" "artificat-repo" {
  for_each = var.repo

  project  = var.project_id
  location = var.location

  repository_id = each.value.repository_id
  description   = each.value.description
  format        = upper(each.value.format)
  labels        = each.value.labels

  dynamic "docker_config" {
    for_each = upper(each.value.format) == "DOCKER" ? [1] : []

    content {
      immutable_tags = each.value.immutable_tags
    }
  }
}

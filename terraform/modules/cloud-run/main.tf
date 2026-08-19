resource "google_cloud_run_v2_service" "cloud_run" {
  project  = var.project_id
  name     = var.service_name
  location = var.location

  deletion_protection = var.deletion_protection
  ingress             = var.ingress
  labels              = var.labels

  template {
    service_account = var.service_account

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    containers {
      image = var.image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      dynamic "env" {
        for_each = var.environment_variables

        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]

    precondition {
      condition     = var.max_instances >= var.min_instances
      error_message = "max_instances must be greater than or equal to min_instances."
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "invoker" {
  for_each = var.invoker_members

  project  = google_cloud_run_v2_service.cloud_run.project
  location = google_cloud_run_v2_service.cloud_run.location
  name     = google_cloud_run_v2_service.cloud_run.name

  role   = "roles/run.invoker"
  member = each.value
}
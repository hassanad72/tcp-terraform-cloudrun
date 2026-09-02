project_id = "gap-dev-ai"
region     = "us-east1"

services = [
  "aiplatform.googleapis.com",
  "artifactregistry.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
  "logging.googleapis.com",
  "monitoring.googleapis.com",
  "run.googleapis.com",
]

vpc_name     = "gap-dev-vpc"
routing_mode = "REGIONAL"

subnets = {
  app = {
    name   = "gap-dev-app-subnet"
    region = "us-east1"
    cidr   = "10.10.0.0/24"
  }
}

firewall_rules = {
  allow_internal = {
    name          = "gap-dev-allow-internal"
    description   = "Allow internal traffic originating from the dev app subnet."
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["10.10.0.0/24"]

    allow = [
      {
        protocol = "tcp"
      },
      {
        protocol = "udp"
      },
      {
        protocol = "icmp"
      },
    ]

    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

service_accounts = {
  cloud_run = {
    name        = "Cloud Run runtime service account"
    account_id  = "gap-dev-cloud-run"
    description = "Runtime identity used by the dev Cloud Run service."
  }
}

iam_role = {
  cloud_run_storage_viewer = {
    role                = "roles/storage.objectViewer"
    service_account_key = "cloud_run"
  }

  cloud_run_vertex_ai_user = {
    role                = "roles/aiplatform.user"
    service_account_key = "cloud_run"
  }
}

service_name = "gcp-ai-dev"

min_instances = 0

max_instances = 4

image = "us-docker.pkg.dev/cloudrun/container/hello"

artificat_repositories = {
  "cloud_run_container" = {
    repository_id = "gap-dev-images"
    description   = "repo for our cloud run application"
    format        = "DOCKER"
    labels = {
      environment = "dev"
      managed_by  = "terraform"
    }
    immutable_tags = false
  }
}
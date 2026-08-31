module "workload_identity" {
  source = "../modules/workload-identity"

  project_id        = var.project_id
  github_repository = "hassanad72/tcp-terraform-cloudrun"

  project_roles = [
    "roles/artifactregistry.admin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/run.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountUser",
    "roles/aiplatform.user",
  ]
}

resource "google_storage_bucket_iam_member" "terraform_state" {
  bucket = var.state_bucket_name
  role   = "roles/storage.objectAdmin"
  member = module.workload_identity.terraform_service_account_member
}

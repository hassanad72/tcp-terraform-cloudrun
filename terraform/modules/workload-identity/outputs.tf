output "workload_identity_pool_name" {
  description = "Fully qualified name of the GitHub Workload Identity Pool."
  value       = google_iam_workload_identity_pool.github.name
}

output "workload_identity_provider" {
  description = "Provider name supplied to google-github-actions/auth."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "terraform_service_account_email" {
  description = "Email of the service account impersonated by GitHub Actions."
  value       = google_service_account.terraform_ci.email
}

output "terraform_service_account_member" {
  description = "IAM member string for the Terraform CI service account."
  value       = google_service_account.terraform_ci.member
}

output "github_repository_principal_set" {
  description = "Federated repository identity allowed to impersonate the Terraform CI service account."
  value       = google_service_account_iam_member.github.member
}

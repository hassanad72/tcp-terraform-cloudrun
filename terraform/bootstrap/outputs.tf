output "workload_identity_provider" {
  description = "Provider name used by GitHub Actions."
  value       = module.workload_identity.workload_identity_provider
}

output "terraform_service_account_email" {
  description = "Terraform CI service account email."
  value       = module.workload_identity.terraform_service_account_email
}
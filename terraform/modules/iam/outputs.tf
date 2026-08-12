output "service_account_emails" {
  description = "Service account email addresses keyed by the input map keys."
  value = {
    for key, service_account in google_service_account.service_account :
    key => service_account.email
  }
}

output "service_account_ids" {
  description = "Service account resource IDs keyed by the input map keys."
  value = {
    for key, service_account in google_service_account.service_account :
    key => service_account.id
  }
}

output "service_account_names" {
  description = "Fully qualified service account names keyed by the input map keys."
  value = {
    for key, service_account in google_service_account.service_account :
    key => service_account.name
  }
}

output "service_account_members" {
  description = "IAM member strings for the service accounts, keyed by the input map keys."
  value = {
    for key, service_account in google_service_account.service_account :
    key => service_account.member
  }
}

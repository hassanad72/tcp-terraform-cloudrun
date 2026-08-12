resource "google_service_account" "service_account" {
  for_each = var.service_accounts

  project      = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.name
  description  = each.value.description
}

resource "google_project_iam_member" "role" {
  for_each = var.iam_role

  project = var.project_id
  role    = each.value.role
  member  = try(google_service_account.service_account[each.value.service_account_key].member, null)

  lifecycle {
    precondition {
      condition     = contains(keys(var.service_accounts), each.value.service_account_key)
      error_message = "IAM role assignment '${each.key}' references an unknown service_account_key '${each.value.service_account_key}'."
    }
  }
}

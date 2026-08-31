# Terraform Platform Standards

## TF-001 — Destructive changes

Terraform plans that destroy or replace resources must be marked high risk and require manual review.

## TF-002 — Public access

Resources granting access to `allUsers` or `allAuthenticatedUsers` must be flagged. Public access must be explicitly justified.

## TF-003 — IAM least privilege

Basic roles such as `roles/owner`, `roles/editor`, and `roles/viewer` should not be assigned. Prefer narrowly scoped predefined roles.

## TF-004 — Service-account keys

Long-lived Google service-account keys must not be created. Workload Identity Federation should be used for external workloads.

## TF-005 — Required labels

Supported resources should include at least:

- `environment`
- `managed_by`

The `managed_by` label should be set to `terraform`.

## TF-006 — Resource locations

Resources must use an approved GCP region. The currently approved development region is `us-east1`.

## TF-007 — Terraform state

Terraform state must use a remote GCS backend. State files and plan files must not be committed to Git.

## TF-008 — Cloud Run images

Cloud Run application images should come from the project’s Artifact Registry repository. Mutable tags such as `latest` should not be used.

## TF-009 — Cloud Run runtime identity

Cloud Run services must use a dedicated service account rather than the default Compute Engine service account.

## TF-010 — Secret handling

Secrets must not be stored directly in Terraform variables, `terraform.tfvars`, source code, or GitHub workflow files.
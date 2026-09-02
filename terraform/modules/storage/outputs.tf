output "bucket_ids" {
  description = "Cloud Storage bucket IDs keyed by their input map keys."

  value = {
    for key, bucket in google_storage_bucket.bucket :
    key => bucket.id
  }
}

output "bucket_names" {
  description = "Cloud Storage bucket names keyed by their input map keys."

  value = {
    for key, bucket in google_storage_bucket.bucket :
    key => bucket.name
  }
}

output "bucket_urls" {
  description = "Cloud Storage URLs keyed by their input map keys."

  value = {
    for key, bucket in google_storage_bucket.bucket :
    key => "gs://${bucket.name}"
  }
}


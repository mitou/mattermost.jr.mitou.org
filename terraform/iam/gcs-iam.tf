resource "google_storage_bucket_iam_binding" "gcs-iam-mitou-jr-tf-iam" {
  bucket = "mitou-jr-tf-iam"
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
  ]
}

resource "google_storage_bucket_iam_binding" "gcs-iam-mitou-jr-tf-basic" {
  bucket = "mitou-jr-tf-basic"
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}",
  ]
}
locals {
  tf-bucket-accessibles = [
    "projectViewer:mitou-jr",
    "serviceAccount:${google_service_account.sa-ga-planner.email}",
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}"
  ]
}

resource "google_storage_bucket_iam_binding" "iam-tf-bucket-sa-binding" {
  bucket  = "mitou-jr-tf-iam"
  role    = "roles/storage.objectAdmin"
  members = local.tf-bucket-accessibles
}

resource "google_storage_bucket_iam_binding" "basic-tf-bucket-sa-binding" {
  bucket  = "mitou-jr-tf-basic"
  role    = "roles/storage.objectAdmin"
  members = local.tf-bucket-accessibles
}
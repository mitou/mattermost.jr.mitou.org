locals {
  tf-bucket-accessibles = [
    "projectViewer:mitou-jr",
    "serviceAccount:${google_service_account.sa-ga-planner.email}",
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}"
  ]

  secret-accessibles = [
      "user:kyasbal1994@gmail.com",
      "user:nishio.hirokazu@gmail.com"
  ]

  main-bucket-accessibles = [
    "serviceAccount:${google_service_account.wi-mattermost-primary.email}"
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
resource "google_storage_bucket_iam_binding" "secret-bucket-access-binding"{
  bucket  = "mitou-jr-secret"
  role    = "roles/storage.objectAdmin"
  members = local.secret-accessibles
}

resource "google_storage_bucket_iam_binding" "main-bucket-access-binding"{
  bucket  = "mitou-jr"
  role    = "roles/storage.objectAdmin"
  members = concat(local.secret-accessibles,local.main-bucket-accessibles)
}
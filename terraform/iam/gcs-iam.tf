resource "google_storage_bucket_iam_binding" "gcs-iam-mitou-jr-tf-iam" {
  bucket = "mitou-jr-tf-iam"
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
  ]
}

resource "google_storage_bucket_iam_binding" "gcs-iam-mitou-jr-tf-basic" {
  bucket = "mitou-jr-tf-basic"
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}",
  ]
}

variable "planner-accessible-buckets" {
  type = set(string)
  default = [
    "mitou-jr-tf-iam",
    "mitou-jr-tf-basic"
  ]
}

resource "google_storage_bucket_iam_member" "planner-tf-bucket-sa-binding" {
  for_each = var.planner-accessible-buckets
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${google_service_account.sa-ga-planner.email}"
  bucket   = each.value
}


resource "google_storage_bucket_iam_member" "iam-tf-bucket-sa-binding" {
  bucket = "mitou-jr-tf-iam"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.sa-ga-iam-applier.email}"
}

resource "google_storage_bucket_iam_member" "basic-tf-bucket-sa-binding" {
  bucket = "mitou-jr-tf-basic"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.sa-ga-basic-applier.email}"
}

resource "google_storage_bucket_iam_member" "bucket-sa-binding" {
  bucket = "mitou-jr"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.sa-ga-basic-applier.email}"
}
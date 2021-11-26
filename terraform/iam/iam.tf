resource "google_project_iam_binding" "viewers" {
  role    = "roles/viewer"
  project = "mitou-jr"

  members = [
    "user:nishio.hirokazu@gmail.com",
  ]
}

resource "google_service_account" "sa-ga-iam-applier" {
  account_id   = "ga-iam-applier"
  display_name = "Github Action用でIAMを適用するためのサービスアカウント"
}

resource "google_service_account" "sa-ga-basic-applier" {
  account_id   = "ga-basic-applier"
  display_name = "Github Action用でIAM以外の要素を適用するためのサービスアカウント"
}

resource "google_project_iam_binding" "iam-binding-iam-applier" {
  role    = "roles/iam.securityAdmin"
  project = "mitou-jr"

  members = [
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
  ]
}

variable "basic-sa-iam-roles" {
  type = set(string)
  default = [
    "roles/storage.admin",
    "roles/container.admin",
    "roles/cloudsql.admin"
  ]
}

resource "google_project_iam_binding" "iam-binding-basic-applier" {
  for_each = var.basic-sa-iam-roles
  project = "mitou-jr"
  members = [
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}",
  ]
  role = each.value
} 

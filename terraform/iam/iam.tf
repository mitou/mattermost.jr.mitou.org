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
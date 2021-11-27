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

resource "google_service_account" "sa-ga-planner" {
  account_id   = "ga-planner"
  display_name = "Github Action用でPlanの時に利用するサービスアカウント"
}

variable "applier-iam-sa-iam-roles" {
  type = set(string)
  default = [
    "roles/iam.securityAdmin",
    "projects/mitou-jr/roles/tfplanner"
  ]
}


resource "google_project_iam_binding" "iam-binding-iam-applier" {
  for_each = var.applier-iam-sa-iam-roles
  role     = each.value
  project  = "mitou-jr"
  members = [
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
  ]
}

variable "planner-sa-iam-roles" {
  type = set(string)
  default = [
    "roles/viewer",
    "projects/mitou-jr/roles/tfplanner"
  ]
}

resource "google_project_iam_binding" "iam-binding-planner" {
  for_each = var.planner-sa-iam-roles
  role     = each.value
  project  = "mitou-jr"

  members = [
    "serviceAccount:${google_service_account.sa-ga-planner.email}",
  ]
}

variable "basic-sa-iam-roles" {
  type = set(string)
  default = [
    "roles/compute.networkAdmin",
    "roles/storage.admin",
    "roles/container.admin",
    "roles/cloudsql.admin"
  ]
}

resource "google_project_iam_binding" "iam-binding-basic-applier" {
  for_each = var.basic-sa-iam-roles
  project  = "mitou-jr"
  members = [
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}",
  ]
  role = each.value
} 
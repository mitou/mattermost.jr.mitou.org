

locals {
  project-viewers = [
    "user:kyasbal1994@gmail.com",
    "user:nishio.hirokazu@gmail.com",
    "serviceAccount:${google_service_account.sa-ga-planner.email}"
  ]

  sa-tfplanners = [
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}",
    "serviceAccount:${google_service_account.sa-ga-planner.email}"
  ]
}
resource "google_project_iam_binding" "viewers" {
  role    = "roles/viewer"
  project = "mitou-jr"
  members = local.project-viewers
}


resource "google_project_iam_binding" "tf-planners" {
  role    = "projects/mitou-jr/roles/tfplanner"
  project = "mitou-jr"
  members = concat(local.project-viewers, local.sa-tfplanners)
}

variable "applier-iam-sa-iam-roles" {
  type = set(string)
  default = [
    "roles/iam.securityAdmin"
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
  members  = ["serviceAccount:${google_service_account.sa-ga-basic-applier.email}"]
  role     = each.value
}

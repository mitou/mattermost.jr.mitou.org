

locals {
  projectid = "mitou-jr"
  project-viewers = [
    "user:sminemoto@ho.mitou.org",
    "serviceAccount:${google_service_account.sa-ga-planner.email}"
  ]

  admin-access = [
    "user:kyasbal1994@gmail.com",
    "user:nishio.hirokazu@gmail.com",
    "user:xpadev@gmail.com",
  ]

  project-viewers-and-admin = concat(local.project-viewers, local.admin-access)

  sa-keyuser = [
    "serviceAccount:service-233207969476@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:${google_service_account.wi-mattermost-primary.email}"
  ]
  sa-tfplanners = [
    "serviceAccount:${google_service_account.sa-ga-iam-applier.email}",
    "serviceAccount:${google_service_account.sa-ga-basic-applier.email}",
    "serviceAccount:${google_service_account.sa-ga-planner.email}"
  ]

  workloadIdenitiyUsers = [
    {
      gsa           = "${google_service_account.wi-mattermost-primary.name}",
      ksa_namespace = "mattermost",
      ksa_name      = "mattermost-primary"
    },
    {
      gsa           = "${google_service_account.wi-secret-mattermost-primary.name}",
      ksa_namespace = "default",
      ksa_name      = "external-secrets"
    }
  ]
}
resource "google_project_iam_binding" "viewers" {
  role    = "roles/viewer"
  project = "mitou-jr"
  members = local.project-viewers-and-admin
}


resource "google_project_iam_binding" "tf-planners" {
  role    = "projects/mitou-jr/roles/tfplanner"
  project = "mitou-jr"
  members = concat(local.project-viewers-and-admin, local.sa-tfplanners)
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

resource "google_project_iam_binding" "iam-binding-k8s-operation" {
  role    = "roles/container.developer"
  project = "mitou-jr"
  members = local.admin-access
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


resource "google_project_iam_binding" "kms-key-users" {
  project = "mitou-jr"
  members = concat(local.admin-access, local.sa-keyuser)
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}

resource "google_service_account_iam_binding" "wi-bindings" {
  for_each           = { for i in local.workloadIdenitiyUsers : "${i.ksa_namespace}/${i.ksa_name}" => i }
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = each.value.gsa
  members = [
    "serviceAccount:mitou-jr.svc.id.goog[${each.value.ksa_namespace}/${each.value.ksa_name}]"
  ]
}

resource "google_project_iam_binding" "monitoring-pubsub" {
  role    = "roles/pubsub.publisher"
  project = "mitou-jr"
  members = [
    "serviceAccount:service-233207969476@gcp-sa-monitoring-notification.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "secret-manager" {
  project = "mitou-jr"
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.wi-secret-mattermost-primary.email}",
  ]
}

resource "google_project_iam_binding" "pod_status_updater_binding" {
  project = "mitou-jr"
  role = google_project_iam_custom_role.pod_status_updater.id
  members = [
    "serviceAccount:${google_service_account.wi-mattermost-primary.email}",
  ]
}

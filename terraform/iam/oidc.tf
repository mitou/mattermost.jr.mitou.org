# サービスアカウントの鍵をGithub Action側に登録しなくとも使えるようにするためのWorkload Identity関連のリソース

resource "google_iam_workload_identity_pool" "github-action-pool" {
  provider                  = google-beta
  project                   = "mitou-jr"
  workload_identity_pool_id = "github-action"
  display_name              = "Github-Action-WI-pool"
  description               = "Github Action Workload identity pool"
}

resource "google_iam_workload_identity_pool_provider" "github-action-pool-provider" {
  provider                           = google-beta
  project = "mitou-jr"
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-action-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-action"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
    allowed_audiences = ["https://github.com/mitou/mattermost.jr.mitou.org"]
  }
}

resource "google_service_account_iam_binding" "workload_identity_binding-iam" {
  service_account_id = google_service_account.sa-ga-iam-applier.id
  role = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/233207969476/locations/global/workloadIdentityPools/github-action/attribute.repository/mattermost.jr.mitou.org"
  ]
}
resource "google_service_account_iam_binding" "workload_identity_binding-basic" {
  service_account_id = google_service_account.sa-ga-basic-applier.id
  role = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/233207969476/locations/global/workloadIdentityPools/github-action/attribute.repository/mattermost.jr.mitou.org"
  ]
}
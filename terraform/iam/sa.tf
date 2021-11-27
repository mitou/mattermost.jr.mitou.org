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
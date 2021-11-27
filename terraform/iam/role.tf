resource "google_project_iam_custom_role" "tfplanner" {
  role_id     = "tfplanner"
  title       = "Terraform planner"
  description = "roles/viewerに加えて必要なTerraform planのための権限"
  permissions = ["storage.buckets.getIamPolicy", "iam.serviceAccounts.get", "iam.workloadIdentityPools.get"]
}
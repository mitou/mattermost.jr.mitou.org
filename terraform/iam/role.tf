resource "google_project_iam_custom_role" "tfplanner" {
  role_id     = "tfplanner"
  title       = "Terraform planner"
  description = "roles/viewerに加えて必要なTerraform planのための権限"
  permissions = [
    "storage.buckets.getIamPolicy",
    "iam.serviceAccounts.get",
    "iam.workloadIdentityPools.get",
    "iam.workloadIdentityPoolProviders.get",
    "cloudkms.keyRings.get",
    "cloudkms.cryptoKeys.get",
    "dns.changes.get",
    "dns.changes.list",
    "dns.dnsKeys.get",
    "dns.dnsKeys.list",
    "dns.managedZoneOperations.get",
    "dns.managedZoneOperations.list",
    "dns.managedZones.get",
    "dns.managedZones.list",
    "dns.policies.get",
    "dns.policies.list",
    "dns.projects.get",
    "dns.resourceRecordSets.get",
    "dns.resourceRecordSets.list",
    "dns.responsePolicies.get",
    "dns.responsePolicies.list",
    "dns.responsePolicyRules.get",
    "dns.responsePolicyRules.list",
  ]
}

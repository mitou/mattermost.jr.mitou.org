resource "google_project" "gcp_project" {
    
  name       = "MitouJr"
  project_id = "mitou-jr"
  billing_account     = "${var.billing_account}"
  skip_delete = true
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"

  disable_dependent_services = true
}
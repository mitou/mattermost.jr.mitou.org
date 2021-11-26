resource "google_container_cluster" "primary" {
  name     = "primary-cluster"
  location = "asia-northeast1"

  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  enable_autopilot = true
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }
}

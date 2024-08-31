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

  # アプリケーションレイヤでのシークレットの暗号化を有効にする
  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.primary-key.id
  }

  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    recurring_window {
      start_time = "2019-01-01T17:00:00Z" //+9:00 -> 02:00:00 JST
      end_time   = "2019-01-01T22:00:00Z" //+9:00 -> 07:00:00 JST
      recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
    }
  }
}

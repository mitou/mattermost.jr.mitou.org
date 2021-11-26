resource "google_compute_network" "default" {
  name                    = "default"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "main-subnet"
  ip_cidr_range = "10.146.0.0/20"
  region        = "asia-northeast1"
  network       = google_compute_network.default.id
}

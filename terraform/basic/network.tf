resource "google_compute_network" "default" {
  name                    = "default"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "main-subnet"
  ip_cidr_range = "10.10.10.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.default.id
   secondary_ip_range  = [
    {
        range_name    = "services"
        ip_cidr_range = "10.10.11.0/24"
    },
    {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/20"
    }
  ]
}

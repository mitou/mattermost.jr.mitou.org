resource "google_compute_firewall" "default" {
  name      = "allow-egress"
  network   = google_compute_network.default.name
  direction = "EGRESS"
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "ssh" {
  name      = "allow-ssh"
  network   = google_compute_network.default.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-hc" {
  name      = "allow-hc"
  network   = google_compute_network.default.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["9376"]
  }
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

resource "google_compute_firewall" "allow-mattertmost" {
  name      = "allow-mattermost"
  network   = google_compute_network.default.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["8000", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
}


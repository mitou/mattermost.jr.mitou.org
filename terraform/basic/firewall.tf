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
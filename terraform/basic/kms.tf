resource "google_kms_key_ring" "primary-keyring" {
  name     = "primary-keyring"
  location = "asia-northeast1"
}

resource "google_kms_crypto_key" "primary-key" {
  name            = "primary-key"
  key_ring        = google_kms_key_ring.primary-keyring.id

  lifecycle {
    prevent_destroy = true
  }
}


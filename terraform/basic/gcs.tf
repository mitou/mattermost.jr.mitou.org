resource "google_storage_bucket" "default" {
  name                        = "mitou-jr"
  location                    = "asia-northeast1"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "secrets" {
  name                        = "mitou-jr-secret"
  location                    = "asia-northeast1"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}


resource "google_storage_bucket" "gcs-tf-iam" {
  name                        = "mitou-jr-tf-iam"
  location                    = "asia-northeast1"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "gcs-tf-basic" {
  name                        = "mitou-jr-tf-basic"
  location                    = "asia-northeast1"
  uniform_bucket_level_access = true
}
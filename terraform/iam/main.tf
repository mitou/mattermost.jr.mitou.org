provider "google" {
  project = "mitou-jr"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

terraform {
  backend "gcs" {
    bucket = "mitou-jr-tf-iam"
  }
}
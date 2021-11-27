resource "google_sql_database_instance" "primary" {
  name             = "primary"
  database_version = "POSTGRES_11"
  region           = "asia-northeast1"

  settings {
    tier = "db-f1-micro"
  }
}

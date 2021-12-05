resource "google_sql_database_instance" "primary" {
  name             = "primary"
  database_version = "POSTGRES_11"
  region           = "asia-northeast1"

  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      location                       = "asia-northeast1"
      transaction_log_retention_days = 3
      backup_retention_settings {
        retained_backups = 3
      }
    }
  }

}

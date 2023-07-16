resource "google_monitoring_notification_channel" "default" {
  display_name = "Mattermost notification channel"
  type         = "pubsub"
  labels = {
    topic = "projects/mitou-jr/topics/mattermost-alert"
  }
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Mattermost notification email"
  type         = "email"
  labels = {
    email_address = "kyasbal1994@gmail.com"
  }
}
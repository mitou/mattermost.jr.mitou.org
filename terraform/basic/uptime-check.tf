resource "google_monitoring_uptime_check_config" "https_check" {
  provider = google-beta
  display_name = "Health check for Mattermost server"
  timeout      = "10s"
  period       = "60s"
  selected_regions = [
    "ASIA_PACIFIC",
    "EUROPE",
    "USA_VIRGINIA",
  ]

  http_check {
    path         = "/api/v4/system/ping"
    port         = "443"
    use_ssl      = true
    validate_ssl = true
    accepted_response_status_codes {
      status_value = 200
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "mitou-jr"
      host       = "mattermost.jr.mitou.org"  # 監視対象のホスト名またはIPアドレスを記載します
    }
  }

  content_matchers {
    content = "OK"
    matcher = "CONTAINS_STRING"
  }

  checker_type = "STATIC_IP_CHECKERS"
}

resource "google_monitoring_alert_policy" "https_check_alert" {
  display_name = "Mattermost healthcheck alert"
  combiner     = "OR"
  conditions {
    display_name = "Mattermost healthcheck alert"

    condition_threshold {
      # filter に 稼働時間チェックの指標を指定して、関連づけています。
      filter          = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = \"${google_monitoring_uptime_check_config.https_check.uptime_check_id}\""
      duration        = "0s"
      threshold_value = 1  # 失敗が1回より多くなったときにアラートを通知
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period     = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.default.id,
    google_monitoring_notification_channel.email.id
  ]
  enabled     = true

  depends_on = [
    google_monitoring_uptime_check_config.https_check
  ]
}

resource "google_compute_health_check" "http-health-check" {
  name = "http-health-check"

  timeout_sec        = 3
  check_interval_sec = 3

  http_health_check {
    request_path = "/api/v4/system/ping"
    port         = 8000
  }
}

resource "google_compute_backend_service" "default" {
  name                    = "backend-service"
  health_checks           = [google_compute_health_check.http-health-check.id]
  custom_response_headers = ["Strict-Transport-Security:max-age=31536000; includeSubDomains; preload"]
  backend {
    group          = "projects/mitou-jr/zones/asia-northeast1-a/networkEndpointGroups/mattermost"
    balancing_mode = "RATE"
    max_rate       = 10000
  }
  backend {
    group          = "projects/mitou-jr/zones/asia-northeast1-b/networkEndpointGroups/mattermost"
    balancing_mode = "RATE"
    max_rate       = 10000
  }

  backend {
    group          = "projects/mitou-jr/zones/asia-northeast1-c/networkEndpointGroups/mattermost"
    balancing_mode = "RATE"
    max_rate       = 10000
  }

}


resource "google_compute_url_map" "default" {
  name        = "urlmap"
  description = "a description"

  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["mattermost.jr.mitou.org"]
    path_matcher = "primary"
  }
  path_matcher {
    name            = "primary"
    default_service = google_compute_backend_service.default.id
    path_rule {
      paths   = ["/"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "primary-https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "google_compute_forwarding_rule" {
  name       = "l7-forwarding-rule"
  ip_address = google_compute_global_address.lb-address.address
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "primary-cert"

  managed {
    domains = ["mattermost.jr.mitou.org."] # TODO: 変更
  }
}

resource "google_compute_url_map" "http-to-https" {
  name = "http-to-https-redirect"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "PERMANENT_REDIRECT"
  }
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "my-http-proxy"
  url_map = google_compute_url_map.http-to-https.self_link
}

resource "google_compute_global_forwarding_rule" "http-redirect" {
  name       = "my-fwrule-http-v4"
  target     = google_compute_target_http_proxy.proxy.self_link
  ip_address = google_compute_global_address.lb-address.address
  port_range = "80"
}

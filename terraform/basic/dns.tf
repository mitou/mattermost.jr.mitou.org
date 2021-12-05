resource "google_dns_managed_zone" "primary-zone" {
  name        = "mattermost-dnszone"
  dns_name    = "mattermost.jr.mitou.org."
  description = "mattermost.jr.mitou.org以下のドメインの管理"
}

resource "google_dns_record_set" "primary-a-record" {
  name = google_dns_managed_zone.primary-zone.dns_name
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.primary-zone.name

  rrdatas = [google_compute_global_address.lb-address.address] # TODO: replace this old ip
}

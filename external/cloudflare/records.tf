data "tailscale_device" "dejima_ar3s3ru_dev" {
  hostname = "dejima.ar3s3ru.dev"
}

data "cloudflare_zone" "ar3s3ru-dev" {
  name = "ar3s3ru.dev"
}

resource "cloudflare_record" "dejima_intranet_resources" {
  for_each = toset([
    "transmission",
    "jellyseerr"
  ])

  name    = each.key
  zone_id = data.cloudflare_zone.ar3s3ru-dev.id
  comment = "This service must only be exposed through my private Tailnet."
  type    = "A"
  value   = data.tailscale_device.dejima_ar3s3ru_dev.addresses[0]
}

data "tailscale_device" "dejima_ar3s3ru_dev" {
  hostname = "dejima.ar3s3ru.dev"
}

data "tailscale_device" "momonoke_ar3s3ru_dev" {
  hostname = "momonoke.ar3s3ru.dev"
}

data "cloudflare_zone" "ar3s3ru-dev" {
  name = "ar3s3ru.dev"
}

resource "cloudflare_record" "dejima_intranet_resources" {
  for_each = toset([
    "transmission",
    "jellyseerr",
    "k8s.dejima",
    "secrets"
  ])

  name    = each.key
  zone_id = data.cloudflare_zone.ar3s3ru-dev.id
  comment = "This service must only be exposed through my private Tailnet."
  type    = "CNAME"
  value   = data.tailscale_device.dejima_ar3s3ru_dev.name
}

resource "cloudflare_record" "momonoke_intranet_resources" {
  for_each = toset([
    "berlin.home",
    "k8s.momonoke"
  ])

  name    = each.key
  zone_id = data.cloudflare_zone.ar3s3ru-dev.id
  comment = "This service must only be exposed through my private Tailnet."
  type    = "CNAME"
  value   = data.tailscale_device.momonoke_ar3s3ru_dev.name
}


data "cloudflare_zone" "ar3s3ru-dev" {
  name = "ar3s3ru.dev"
}

locals {
  dejima_intranet_ip_addr = "100.64.0.7"
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
  value   = local.dejima_intranet_ip_addr
}

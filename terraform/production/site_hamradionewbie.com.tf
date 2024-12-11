################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "hamradionewbie_com" {
  zone = "hamradionewbie.com"

  account_id = var.cloudflare_account_id
  paused     = false
  plan       = "free"
  type       = "full"
}

########################################
### All other records
########################################

resource "cloudflare_record" "hamradionewbie_com_a" {
  for_each = toset(local.hamradionewbie_com_github_pages_ipv4_addresses)

  zone_id = cloudflare_zone.hamradionewbie_com.id
  name    = "@"
  type    = "A"
  ttl     = 3600
  content = each.value
  proxied = false
}

resource "cloudflare_record" "hamradionewbie_com_aaaa" {
  for_each = toset(local.hamradionewbie_com_github_pages_ipv6_addresses)

  zone_id = cloudflare_zone.hamradionewbie_com.id
  name    = "@"
  type    = "AAAA"
  ttl     = 3600
  content = each.value
  proxied = false
}

resource "cloudflare_record" "hamradionewbie_com_caa" {
  for_each = toset(local.caa_record_tags)

  zone_id = cloudflare_zone.hamradionewbie_com.id
  name    = "@"
  type    = "CAA"
  ttl     = 3600
  data {
    flags = "0"
    tag   = each.value
    value = "letsencrypt.org"
  }
}

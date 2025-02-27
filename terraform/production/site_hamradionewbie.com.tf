################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "hamradionewbie_com" {
  name = "hamradionewbie.com"

  account = {
    id = var.cloudflare_account_id
  }
  type = "full"
}

########################################
### All other records
########################################

resource "cloudflare_dns_record" "hamradionewbie_com_a" {
  for_each = toset(local.hamradionewbie_com_github_pages_ipv4_addresses)

  zone_id = cloudflare_zone.hamradionewbie_com.id
  name    = "@"
  type    = "A"
  ttl     = 3600
  content = each.value
  proxied = false
}

resource "cloudflare_dns_record" "hamradionewbie_com_aaaa" {
  for_each = toset(local.hamradionewbie_com_github_pages_ipv6_addresses)

  zone_id = cloudflare_zone.hamradionewbie_com.id
  name    = "@"
  type    = "AAAA"
  ttl     = 3600
  content = each.value
  proxied = false
}

resource "cloudflare_dns_record" "hamradionewbie_com_caa" {
  for_each = toset(local.lets_encrypt_caa_record_tags)

  zone_id = cloudflare_zone.hamradionewbie_com.id
  name    = "@"
  type    = "CAA"
  ttl     = 3600
  data = {
    flags = 0
    tag   = each.value
    value = "letsencrypt.org"
  }
}

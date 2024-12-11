################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "mariapietropola_com" {
  zone = "mariapietropola.com"

  account_id = var.cloudflare_account_id
  paused     = false
  plan       = "free"
  type       = "full"
}

########################################
### All other records
########################################

resource "cloudflare_record" "mariapietropola_com_a" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "@"
  type    = "A"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv4_address
  proxied = false
}

resource "cloudflare_record" "mariapietropola_com_aaaa" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "@"
  type    = "AAAA"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv6_address
  proxied = false
}

resource "cloudflare_record" "mariapietropola_com_a_www" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "www"
  type    = "A"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv4_address
  proxied = false
}

resource "cloudflare_record" "mariapietropola_com_aaaa_www" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "www"
  type    = "AAAA"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv6_address
  proxied = false
}

resource "cloudflare_record" "mariapietropola_com_caa" {
  for_each = toset(local.caa_record_tags)

  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "@"
  type    = "CAA"
  ttl     = 3600
  data {
    flags = "0"
    tag   = each.value
    value = "letsencrypt.org"
  }
}

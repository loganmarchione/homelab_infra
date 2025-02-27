################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "mariapietropola_com" {
  name = "mariapietropola.com"

  account = {
    id = var.cloudflare_account_id
  }
  type = "full"
}

########################################
### All other records
########################################

resource "cloudflare_dns_record" "mariapietropola_com_a" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "@"
  type    = "A"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv4_address
  proxied = false
}

resource "cloudflare_dns_record" "mariapietropola_com_aaaa" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "@"
  type    = "AAAA"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv6_address
  proxied = false
}

resource "cloudflare_dns_record" "mariapietropola_com_a_www" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "www"
  type    = "A"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv4_address
  proxied = false
}

resource "cloudflare_dns_record" "mariapietropola_com_aaaa_www" {
  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "www"
  type    = "AAAA"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv6_address
  proxied = false
}

resource "cloudflare_dns_record" "mariapietropola_com_caa" {
  for_each = toset(local.lets_encrypt_caa_record_tags)

  zone_id = cloudflare_zone.mariapietropola_com.id
  name    = "@"
  type    = "CAA"
  ttl     = 3600
  data = {
    flags = 0
    tag   = each.value
    value = "letsencrypt.org"
  }
}

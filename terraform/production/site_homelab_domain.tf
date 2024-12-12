################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "homelab_domain" {
  zone = var.homelab_domain

  account_id = var.cloudflare_account_id
  paused     = false
  plan       = "free"
  type       = "full"
}

########################################
### All other records
########################################

resource "cloudflare_record" "homelab_domain_caa" {
  for_each = toset(local.lets_encrypt_caa_record_tags)

  zone_id = cloudflare_zone.homelab_domain.id
  name    = "@"
  type    = "CAA"
  ttl     = 3600
  data {
    flags = "0"
    tag   = each.value
    value = "letsencrypt.org"
  }
}

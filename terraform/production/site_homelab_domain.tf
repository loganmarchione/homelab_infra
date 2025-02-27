################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "homelab_domain" {
  name = var.homelab_domain

  account = {
    id = var.cloudflare_account_id
  }
  type = "full"
}

########################################
### All other records
########################################

resource "cloudflare_dns_record" "homelab_domain_caa" {
  for_each = toset(local.lets_encrypt_caa_record_tags)

  zone_id = cloudflare_zone.homelab_domain.id
  name    = "@"
  type    = "CAA"
  ttl     = 3600
  data = {
    flags = 0
    tag   = each.value
    value = "letsencrypt.org"
  }
}

resource "cloudflare_dns_record" "homelab_domain_dynamic_dns" {
  zone_id = cloudflare_zone.homelab_domain.id
  name    = "ddns"
  type    = "A"
  ttl     = 1800
  content = "1.1.1.1"
  proxied = false

  lifecycle {
    ignore_changes = [
      content
    ]
  }

}

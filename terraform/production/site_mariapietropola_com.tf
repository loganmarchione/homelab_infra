################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "digitalocean_domain" "mariapietropola_com" {
  name = "mariapietropola.com"
}

########################################
### All other records
########################################

resource "digitalocean_record" "mariapietropola_com_a" {
  domain = digitalocean_domain.mariapietropola_com.id
  name   = "@"
  type   = "A"
  ttl    = "1800"
  value  = digitalocean_droplet.web01.ipv4_address
}

resource "digitalocean_record" "mariapietropola_com_aaaa" {
  domain = digitalocean_domain.mariapietropola_com.id
  name   = "@"
  type   = "AAAA"
  ttl    = "1800"
  value  = digitalocean_droplet.web01.ipv6_address
}

resource "digitalocean_record" "mariapietropola_com_a_www" {
  domain = digitalocean_domain.mariapietropola_com.id
  name   = "www"
  type   = "A"
  ttl    = "1800"
  value  = digitalocean_droplet.web01.ipv4_address
}

resource "digitalocean_record" "mariapietropola_com_aaaa_www" {
  domain = digitalocean_domain.mariapietropola_com.id
  name   = "www"
  type   = "AAAA"
  ttl    = "1800"
  value  = digitalocean_droplet.web01.ipv6_address
}

resource "digitalocean_record" "mariapietropola_com_caa_issue" {
  domain = digitalocean_domain.mariapietropola_com.id
  name   = "@"
  type   = "CAA"
  ttl    = "1800"
  flags  = "0"
  tag    = "issue"
  # https://github.com/digitalocean/terraform-provider-digitalocean/issues/1010#issuecomment-1638363717
  value = "letsencrypt.org."
}

resource "digitalocean_record" "mariapietropola_com_caa_issuewild" {
  domain = digitalocean_domain.mariapietropola_com.id
  name   = "@"
  type   = "CAA"
  ttl    = "1800"
  flags  = "0"
  tag    = "issuewild"
  # https://github.com/digitalocean/terraform-provider-digitalocean/issues/1010#issuecomment-1638363717
  value = "letsencrypt.org."
}

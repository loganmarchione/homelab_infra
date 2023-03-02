################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "mariapietropola_com" {
  name = "mariapietropola.com"
}

resource "aws_route53_record" "mariapietropola_com_nameservers" {
  zone_id         = aws_route53_zone.mariapietropola_com.zone_id
  name            = aws_route53_zone.mariapietropola_com.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.mariapietropola_com.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "mariapietropola_com_a" {
  zone_id = aws_route53_zone.mariapietropola_com.zone_id
  name    = ""
  type    = "A"
  ttl     = "3600"
  records = [digitalocean_droplet.web02.ipv4_address]
}

resource "aws_route53_record" "mariapietropola_com_aaaa" {
  zone_id = aws_route53_zone.mariapietropola_com.zone_id
  name    = ""
  type    = "AAAA"
  ttl     = "3600"
  records = [digitalocean_droplet.web02.ipv6_address]
}

resource "aws_route53_record" "mariapietropola_com_www_a" {
  zone_id = aws_route53_zone.mariapietropola_com.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = "mariapietropola.com"
    zone_id                = aws_route53_zone.mariapietropola_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mariapietropola_com_www_aaaa" {
  zone_id = aws_route53_zone.mariapietropola_com.zone_id
  name    = "www"
  type    = "AAAA"

  alias {
    name                   = "mariapietropola.com"
    zone_id                = aws_route53_zone.mariapietropola_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mariapietropola_com_caa" {
  zone_id = aws_route53_zone.mariapietropola_com.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\""
  ]
}

################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "loganandmaria_com" {
  name = "loganandmaria.com"
}

resource "aws_route53_record" "loganandmaria_com_nameservers" {
  zone_id         = aws_route53_zone.loganandmaria_com.zone_id
  name            = aws_route53_zone.loganandmaria_com.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.loganandmaria_com.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "loganandmaria_com_a" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = ""
  type    = "A"
  ttl     = "3600"
  records = [digitalocean_droplet.web02.ipv4_address]
}

resource "aws_route53_record" "loganandmaria_com_aaaa" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = ""
  type    = "AAAA"
  ttl     = "3600"
  records = [digitalocean_droplet.web02.ipv6_address]
}

resource "aws_route53_record" "loganandmaria_com_a_www" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = "loganandmaria.com"
    zone_id                = aws_route53_zone.loganandmaria_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganandmaria_com_aaaa_www" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = "www"
  type    = "AAAA"

  alias {
    name                   = "loganandmaria.com"
    zone_id                = aws_route53_zone.loganandmaria_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganandmaria_com_mx_google" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = ""
  type    = "MX"
  ttl     = "3600"
  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM",
    "15 gubaxfbs3pclxek6tkmakpeeye2l2tveafmdf5xkhumda67hws4q.mx-verification.google.com"
  ]
}

resource "aws_route53_record" "loganandmaria_com_txt" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 include:_spf.google.com ~all"
  ]
}

resource "aws_route53_record" "loganandmaria_com_caa" {
  zone_id = aws_route53_zone.loganandmaria_com.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\""
  ]
}

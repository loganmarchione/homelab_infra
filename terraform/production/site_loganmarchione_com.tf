################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "loganmarchione_com" {
  name = "loganmarchione.com"
}

resource "aws_route53_record" "loganmarchione_com_nameservers" {
  zone_id         = aws_route53_zone.loganmarchione_com.zone_id
  name            = aws_route53_zone.loganmarchione_com.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.loganmarchione_com.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "loganmarchione_com_a" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "A"
  ttl     = "3600"
  records = [digitalocean_droplet.web01.ipv4_address]
}

resource "aws_route53_record" "loganmarchione_com_aaaa" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "AAAA"
  ttl     = "3600"
  records = [digitalocean_droplet.web01.ipv6_address]
}

resource "aws_route53_record" "loganmarchione_com_a_www" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = "loganmarchione.com"
    zone_id                = aws_route53_zone.loganmarchione_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganmarchione_com_aaaa_www" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "www"
  type    = "AAAA"

  alias {
    name                   = "loganmarchione.com"
    zone_id                = aws_route53_zone.loganmarchione_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganmarchione_com_mx_fastmail" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "MX"
  ttl     = "3600"
  records = [
    "10 in1-smtp.messagingengine.com",
    "20 in2-smtp.messagingengine.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_txt" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 include:spf.messagingengine.com ~all",
    "brave-ledger-verification=da1b68a7f01cb62d91c8f3613d1b3ac854a07a2bd376ca38259c0f7834f4f7f9"
  ]
}

resource "aws_route53_record" "loganmarchione_com_cname_fastmail1" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "fm1._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "fm1.loganmarchione.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_cname_fastmail2" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "fm2._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "fm2.loganmarchione.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_cname_fastmail3" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "fm3._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "fm3.loganmarchione.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_caa" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\""
  ]
}

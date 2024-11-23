################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "hamradionewbie_com" {
  name = "hamradionewbie.com"
}

resource "aws_route53_record" "hamradionewbie_com_nameservers" {
  zone_id         = aws_route53_zone.hamradionewbie_com.zone_id
  name            = aws_route53_zone.hamradionewbie_com.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.hamradionewbie_com.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "hamradionewbie_com_a" {
  zone_id = aws_route53_zone.hamradionewbie_com.zone_id
  name    = ""
  type    = "A"
  ttl     = "3600"
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}

resource "aws_route53_record" "hamradionewbie_com_aaaa" {
  zone_id = aws_route53_zone.hamradionewbie_com.zone_id
  name    = ""
  type    = "AAAA"
  ttl     = "3600"
  records = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ]
}

resource "aws_route53_record" "hamradionewbie_com_caa" {
  zone_id = aws_route53_zone.hamradionewbie_com.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\""
  ]
}

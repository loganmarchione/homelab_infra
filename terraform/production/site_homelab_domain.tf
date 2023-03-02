################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "homelab_domain" {
  name = var.homelab_domain
}

resource "aws_route53_record" "homelab_domain_nameservers" {
  zone_id         = aws_route53_zone.homelab_domain.zone_id
  name            = aws_route53_zone.homelab_domain.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.homelab_domain.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "homelab_domain_caa" {
  zone_id = aws_route53_zone.homelab_domain.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\""
  ]
}

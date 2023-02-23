###
### DNS
###

resource "aws_route53_zone" "homelab_domain" {
  name = trimspace(base64decode(var.homelab_domain))
}

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

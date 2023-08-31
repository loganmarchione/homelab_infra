################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "this" {
  name = var.this_name
}

resource "aws_route53_record" "this_nameservers" {
  zone_id         = aws_route53_zone.this.zone_id
  name            = aws_route53_zone.this.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.this.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "this_caa" {
  zone_id = aws_route53_zone.this.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
}

###
### SES
###


#
# loganmarchione.com
#

# Create the domain
resource "aws_ses_domain_identity" "domain_identity" {
  domain = aws_route53_zone.loganmarchione_com.name
}

# Verify the domain
resource "aws_ses_domain_identity_verification" "domain_verification" {
  domain = aws_ses_domain_identity.domain_identity.id
  depends_on = [
    aws_route53_record.amazonses_verification
  ]
}

# DKIM
resource "aws_ses_domain_dkim" "domain_dkim" {
  domain = aws_ses_domain_identity.domain_identity.domain
}

#
# homelab_domain
#

# Create the domain
resource "aws_ses_domain_identity" "domain_identity2" {
  domain = aws_route53_zone.homelab_domain.name
}

# Verify the domain
resource "aws_ses_domain_identity_verification" "domain_verification2" {
  domain = aws_ses_domain_identity.domain_identity2.id
  depends_on = [
    aws_route53_record.amazonses_verification2
  ]
}

# DKIM
resource "aws_ses_domain_dkim" "domain_dkim2" {
  domain = aws_ses_domain_identity.domain_identity2.domain
}

###
### DNS
###

#
# loganmarchione.com
#

# Create DNS records for SES
resource "aws_route53_record" "amazonses_verification" {
  zone_id = aws_route53_zone.loganmarchione_com.id
  name    = "_amazonses.${aws_ses_domain_identity.domain_identity.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    aws_ses_domain_identity.domain_identity.verification_token
  ]
}

# Create DNS records for DKIM
resource "aws_route53_record" "dkim_record" {
  zone_id = aws_route53_zone.loganmarchione_com.id
  name    = "${element(aws_ses_domain_dkim.domain_dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "${element(aws_ses_domain_dkim.domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"
  ]
  count = 3
}

#
# homelab_domain
#

# Create DNS records for SES
resource "aws_route53_record" "amazonses_verification2" {
  zone_id = aws_route53_zone.homelab_domain.id
  name    = "_amazonses.${aws_ses_domain_identity.domain_identity2.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    aws_ses_domain_identity.domain_identity2.verification_token
  ]
}

# Create DNS records for DKIM
resource "aws_route53_record" "dkim_record2" {
  zone_id = aws_route53_zone.homelab_domain.id
  name    = "${element(aws_ses_domain_dkim.domain_dkim2.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "${element(aws_ses_domain_dkim.domain_dkim2.dkim_tokens, count.index)}.dkim.amazonses.com"
  ]
  count = 3
}


################################################################################
### SES
################################################################################

########################################
### loganmarchione.com
########################################

# Create the domain
resource "aws_ses_domain_identity" "loganmarchione_com" {
  domain = aws_route53_zone.loganmarchione_com.name
}

# Verify the domain
resource "aws_ses_domain_identity_verification" "loganmarchione_com" {
  domain = aws_ses_domain_identity.loganmarchione_com.id
  depends_on = [
    aws_route53_record.loganmarchione_com_txt_ses
  ]
}

# DKIM
resource "aws_ses_domain_dkim" "loganmarchione_com" {
  domain = aws_ses_domain_identity.loganmarchione_com.domain
}

########################################
### homelab_domain
########################################

# Create the domain
resource "aws_ses_domain_identity" "homelab_domain" {
  domain = aws_route53_zone.homelab_domain.name
}

# Verify the domain
resource "aws_ses_domain_identity_verification" "homelab_domain" {
  domain = aws_ses_domain_identity.homelab_domain.id
  depends_on = [
    aws_route53_record.homelab_domain_txt_ses
  ]
}

# DKIM
resource "aws_ses_domain_dkim" "homelab_domain" {
  domain = aws_ses_domain_identity.homelab_domain.domain
}

################################################################################
### DNS
################################################################################

########################################
### loganmarchione.com
########################################

# Create DNS records for SES
resource "aws_route53_record" "loganmarchione_com_txt_ses" {
  zone_id = aws_route53_zone.loganmarchione_com.id
  name    = "_amazonses.${aws_ses_domain_identity.loganmarchione_com.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    aws_ses_domain_identity.loganmarchione_com.verification_token
  ]
}

# Create DNS records for DKIM
resource "aws_route53_record" "loganmarchione_com_cname_ses" {
  zone_id = aws_route53_zone.loganmarchione_com.id
  name    = "${element(aws_ses_domain_dkim.loganmarchione_com.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "${element(aws_ses_domain_dkim.loganmarchione_com.dkim_tokens, count.index)}.dkim.amazonses.com"
  ]
  count = 3
}

########################################
### homelab_domain
########################################

# Create DNS records for SES
resource "aws_route53_record" "homelab_domain_txt_ses" {
  zone_id = aws_route53_zone.homelab_domain.id
  name    = "_amazonses.${aws_ses_domain_identity.homelab_domain.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    aws_ses_domain_identity.homelab_domain.verification_token
  ]
}

# Create DNS records for DKIM
resource "aws_route53_record" "homelab_domain_cname_ses" {
  zone_id = aws_route53_zone.homelab_domain.id
  name    = "${element(aws_ses_domain_dkim.homelab_domain.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "${element(aws_ses_domain_dkim.homelab_domain.dkim_tokens, count.index)}.dkim.amazonses.com"
  ]
  count = 3
}


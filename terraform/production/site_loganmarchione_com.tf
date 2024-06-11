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

################################################################################
### Module for static site
################################################################################

module "static_site_loganmarchione_com" {
  source = "github.com/loganmarchione/terraform-aws-static-site?ref=0.1.6"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  # The domain name of the site (**MUST** match the Route53 hosted zone name (e.g., `domain.com`)
  domain_name = "loganmarchione.com"

  # Since this is a static site, we probably don't need versioning, since our source files are stored in git
  bucket_versioning_logs = false
  bucket_versioning_site = false

  # CloudFront settings
  cloudfront_compress                     = true
  cloudfront_default_root_object          = "index.html"
  cloudfront_enabled                      = true
  cloudfront_function_create              = true
  cloudfront_function_filename            = "function.js"
  cloudfront_function_name                = "ReWrites"
  cloudfront_http_version                 = "http2and3"
  cloudfront_ipv6                         = true
  cloudfront_price_class                  = "PriceClass_100"
  cloudfront_ssl_minimum_protocol_version = "TLSv1.2_2021"
  cloudfront_ttl_min                      = 3600
  cloudfront_ttl_default                  = 86400
  cloudfront_ttl_max                      = 2592000
  cloudfront_viewer_protocol_policy       = "redirect-to-https"

  # IAM
  iam_policy_site_updating = true

  # Upload default files
  upload_index  = false
  upload_robots = false
  upload_404    = false
}

################################################################################
### Module for GitHub OIDC role
################################################################################

module "iam_github_oidc_role_loganmarchione_com" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam?ref=v5.39.1"

  name = "GitHubActionsOIDC-loganmarchione-com"
  policies = {
    SiteUpdating-loganmarchione-com = module.static_site_loganmarchione_com.site_updating_iam_policy_arn
  }
  subjects = ["loganmarchione/loganmarchione.com:*"]
}

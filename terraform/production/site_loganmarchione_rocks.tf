################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "loganmarchione_rocks" {
  name = "loganmarchione.rocks"
}

resource "aws_route53_record" "loganmarchione_rocks_nameservers" {
  zone_id         = aws_route53_zone.loganmarchione_rocks.zone_id
  name            = aws_route53_zone.loganmarchione_rocks.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.loganmarchione_rocks.name_servers
}

################################################################################
### Module for static site
################################################################################

module "static_site_loganmarchione_rocks" {
  source = "github.com/loganmarchione/terraform-aws-static-site?ref=0.1.5"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  # The domain name of the site (**MUST** match the Route53 hosted zone name (e.g., `domain.com`)
  domain_name = "loganmarchione.rocks"

  # Since this is a static site, we probably don't need versioning, since our source files are stored in git
  bucket_versioning_logs = false
  bucket_versioning_site = false

  # CloudFront settings
  cloudfront_compress                     = true
  cloudfront_default_root_object          = "index.html"
  cloudfront_enabled                      = true
  cloudfront_function_create              = false
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
  iam_policy_site_updating = false

  # Upload default files
  upload_index  = true
  upload_robots = true
  upload_404    = true
}

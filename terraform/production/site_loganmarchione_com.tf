###
### DNS
###

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

resource "aws_route53_record" "loganmarchione_com_www_a" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = "loganmarchione.com"
    zone_id                = aws_route53_zone.loganmarchione_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganmarchione_com_www_aaaa" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "www"
  type    = "AAAA"

  alias {
    name                   = "loganmarchione.com"
    zone_id                = aws_route53_zone.loganmarchione_com.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganmarchione_com_fastmail_mx" {
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
    "v=spf1 include:spf.messagingengine.com ?all",
    "brave-ledger-verification=da1b68a7f01cb62d91c8f3613d1b3ac854a07a2bd376ca38259c0f7834f4f7f9"
  ]
}

resource "aws_route53_record" "loganmarchione_com_fastmail_dkim1" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "fm1._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "fm1.loganmarchione.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_fastmail_dkim2" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "fm2._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "fm2.loganmarchione.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_fastmail_dkim3" {
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

###
### S3
###

# Resources for /education and /resumes
resource "aws_s3_bucket" "loganmarchione_com_resources" {
  bucket = "loganmarchione-com-resources"

  lifecycle {
    prevent_destroy = true
  }
}

# Make the bucket public
resource "aws_s3_bucket_acl" "loganmarchione_com_resources_acl" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.id
  acl    = "public-read"
}

# Disable bucket versioning
resource "aws_s3_bucket_versioning" "loganmarchione_com_resources_versioning" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "loganmarchione_com_resources_encryption" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "loganmarchione_com_resources_lifecycle" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.id

  rule {
    id     = "30d_move_to_S3_IA"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

###
### Certificates
###

## resource "aws_acm_certificate" "loganmarchione_com" {
##   domain_name       = aws_route53_zone.loganmarchione_com.name
##   validation_method = "DNS"
##   subject_alternative_names = [
##     "*.${aws_route53_zone.loganmarchione_com.name}"
##   ]
## 
##   lifecycle {
##     create_before_destroy = true
##   }
## }
## 
## resource "aws_route53_record" "loganmarchione_com" {
##   for_each = {
##     for dvo in aws_acm_certificate.loganmarchione_com.domain_validation_options : dvo.domain_name => {
##       name   = dvo.resource_record_name
##       record = dvo.resource_record_value
##       type   = dvo.resource_record_type
##     }
##   }
## 
##   allow_overwrite = true
##   zone_id         = aws_route53_zone.loganmarchione_com.zone_id
##   name            = each.value.name
##   type            = each.value.type
##   ttl             = "3600"
##   records         = [each.value.record]
## }
## 
## resource "aws_acm_certificate_validation" "loganmarchione_com" {
##   certificate_arn         = aws_acm_certificate.loganmarchione_com.arn
##   validation_record_fqdns = [for record in aws_route53_record.loganmarchione_com : record.fqdn]
## }

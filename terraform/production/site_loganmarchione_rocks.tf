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

########################################
### All other records
########################################

resource "aws_route53_record" "loganmarchione_rocks_caa" {
  zone_id = aws_route53_zone.loganmarchione_rocks.zone_id
  name    = ""
  type    = "CAA"
  ttl     = "3600"
  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
}

################################################################################
### S3
################################################################################

# Create a bucket
resource "aws_s3_bucket" "loganmarchione_rocks" {
  bucket = "loganmarchione-rocks"

  lifecycle {
    prevent_destroy = true
  }
}

# Make the bucket private
resource "aws_s3_bucket_acl" "loganmarchione_rocks" {
  bucket = aws_s3_bucket.loganmarchione_rocks.id
  acl    = "private"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "loganmarchione_rocks" {
  bucket = aws_s3_bucket.loganmarchione_rocks.id
  # kics-scan ignore-line
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "loganmarchione_rocks" {
  #ts:skip=AWS.S3Bucket.EncryptionandKeyManagement.High.0405 Bucket is already encrypted but not with KMS
  bucket = aws_s3_bucket.loganmarchione_rocks.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "loganmarchione_rocks" {
  bucket                  = aws_s3_bucket.loganmarchione_rocks.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Bucket lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "loganmarchione_rocks" {
  bucket = aws_s3_bucket.loganmarchione_rocks.id

  rule {
    id     = "30d_move_to_S3_IA"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

################################################################################
### ACM + DNS
################################################################################

resource "aws_acm_certificate" "loganmarchione_rocks" {
  # This is needed because CloudFront can only use ACM certs generated in us-east-1
  provider          = aws.us-east-1
  domain_name       = aws_route53_zone.loganmarchione_rocks.name
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${aws_route53_zone.loganmarchione_rocks.name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "loganmarchione_rocks" {
  for_each = {
    for dvo in aws_acm_certificate.loganmarchione_rocks.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.loganmarchione_rocks.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "loganmarchione_rocks" {
  # This is needed because CloudFront can only use ACM certs generated in us-east-1
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.loganmarchione_rocks.arn
  validation_record_fqdns = [for record in aws_route53_record.loganmarchione_rocks : record.fqdn]

  timeouts {
    create = "5m"
  }
}

################################################################################
### CloudFront + DNS
################################################################################

resource "aws_cloudfront_origin_access_control" "loganmarchione_rocks" {
  name                              = "loganmarchione_rocks"
  description                       = "loganmarchione_rocks"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id_loganmarchione_rocks = "loganmarchione_rocks"
}

resource "aws_cloudfront_distribution" "loganmarchione_rocks" {
  origin {
    domain_name              = aws_s3_bucket.loganmarchione_rocks.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.loganmarchione_rocks.id
    origin_id                = local.s3_origin_id_loganmarchione_rocks
  }

  aliases         = [aws_route53_zone.loganmarchione_rocks.name]
  comment         = local.s3_origin_id_loganmarchione_rocks
  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id_loganmarchione_rocks

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.loganmarchione_rocks.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_route53_record" "loganmarchione_rocks_a" {
  zone_id = aws_route53_zone.loganmarchione_rocks.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.loganmarchione_rocks.domain_name
    zone_id                = aws_cloudfront_distribution.loganmarchione_rocks.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "loganmarchione_rocks_aaaa" {
  zone_id = aws_route53_zone.loganmarchione_rocks.zone_id
  name    = ""
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.loganmarchione_rocks.domain_name
    zone_id                = aws_cloudfront_distribution.loganmarchione_rocks.hosted_zone_id
    evaluate_target_health = false
  }
}

# CloudFront access to S3 bucket
resource "aws_s3_bucket_policy" "loganmarchione_rocks" {
  bucket = aws_s3_bucket.loganmarchione_rocks.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "PolicyForCloudFrontAccessToResourcesBucket",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.loganmarchione_rocks.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.loganmarchione_rocks.arn
          }
        }
      },
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*"
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.loganmarchione_rocks.arn}/*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
}

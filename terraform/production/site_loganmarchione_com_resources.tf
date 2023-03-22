################################################################################
### S3
################################################################################

# Create a bucket for resources (e.g., for /education and /resumes)
resource "aws_s3_bucket" "loganmarchione_com_resources" {
  bucket = "loganmarchione-com-resources"

  lifecycle {
    prevent_destroy = true
  }
}

# Make the bucket private
resource "aws_s3_bucket_acl" "loganmarchione_com_resources" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.id
  acl    = "private"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "loganmarchione_com_resources" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.id
  # kics-scan ignore-line
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "loganmarchione_com_resources" {
  #ts:skip=AWS.S3Bucket.EncryptionandKeyManagement.High.0405 Bucket is already encrypted but not with KMS
  bucket = aws_s3_bucket.loganmarchione_com_resources.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "loganmarchione_com_resources" {
  bucket                  = aws_s3_bucket.loganmarchione_com_resources.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Bucket lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "loganmarchione_com_resources" {
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

################################################################################
### CloudFront
################################################################################

resource "aws_cloudfront_origin_access_control" "loganmarchione_com_resources" {
  name                              = "loganmarchione_com_resources"
  description                       = "loganmarchione_com_resources"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "loganmarchione_com_resources"
}

resource "aws_cloudfront_distribution" "loganmarchione_com_resources" {
  origin {
    domain_name              = aws_s3_bucket.loganmarchione_com_resources.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.loganmarchione_com_resources.id
    origin_id                = local.s3_origin_id
  }

  comment         = local.s3_origin_id
  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

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

  # kics-scan ignore-line
  viewer_certificate {
    # kics-scan ignore-line
    cloudfront_default_certificate = true
  }
}

# CloudFront access to S3 bucket
resource "aws_s3_bucket_policy" "loganmarchione_com_resources" {
  bucket = aws_s3_bucket.loganmarchione_com_resources.id
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
        "Resource" : "${aws_s3_bucket.loganmarchione_com_resources.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.loganmarchione_com_resources.arn
          }
        }
      }
    ]
  })
}

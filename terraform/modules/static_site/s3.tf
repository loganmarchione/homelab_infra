################################################################################
### S3
################################################################################

########################################
### Site bucket
########################################

# Create a bucket
resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# Set bucket versioning
resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = var.bucket_versioning
  }
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable logging to log bucket
resource "aws_s3_bucket_logging" "site" {
  bucket = aws_s3_bucket.site.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "s3_${aws_s3_bucket.site.id}/"

  depends_on = [aws_s3_bucket.logging]
}

########################################
### Logging bucket
########################################

# Create a bucket
resource "aws_s3_bucket" "logging" {
  bucket = "${var.bucket_name}-logging"

  lifecycle {
    prevent_destroy = true
  }
}

# Set bucket versioning
resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.id

  versioning_configuration {
    status = var.bucket_versioning
  }
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "30d_move_to_S3_IA"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

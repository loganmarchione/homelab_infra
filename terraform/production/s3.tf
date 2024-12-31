################################################################################
### S3
################################################################################

########################################
### Logging bucket
########################################

# Create a bucket
# Ignore KICS scan: S3 Bucket Logging Disabled
# Reason: This bucket is the logging bucket
# kics-scan ignore-line
resource "aws_s3_bucket" "loganmarchione_logging" {
  bucket = "loganmarchione-logging"

  lifecycle {
    prevent_destroy = true
  }
}

# Make the bucket private
resource "aws_s3_bucket_acl" "loganmarchione_logging" {
  bucket = aws_s3_bucket.loganmarchione_logging.id
  acl    = "log-delivery-write"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "loganmarchione_logging" {
  bucket = aws_s3_bucket.loganmarchione_logging.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "loganmarchione_logging" {
  bucket = aws_s3_bucket.loganmarchione_logging.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "loganmarchione_logging" {
  bucket                  = aws_s3_bucket.loganmarchione_logging.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Bucket lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "loganmarchione_logging" {
  bucket = aws_s3_bucket.loganmarchione_logging.id

  rule {
    id = "30d_move_to_S3_IA_and_1y_delete_old_objects"
    filter {
      prefix = "s3_${aws_s3_bucket.terraform_state.id}/"
    }
    # expire (delete) objects older than 1 year
    expiration {
      days = 365
    }
    status = "Enabled"
    # transition to STANDARD_ID after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

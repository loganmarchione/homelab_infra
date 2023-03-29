################################################################################
### S3
################################################################################

########################################
### Logging bucket
########################################

# Create a bucket
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
  #ts:skip=AWS.S3Bucket.EncryptionandKeyManagement.High.0405 Bucket is already encrypted but not with KMS
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
    id     = "30d_move_to_S3_IA"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

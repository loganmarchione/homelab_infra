################################################################################
### S3
################################################################################

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

# Enable bucket versioning
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

# Make sure the bucket is public
resource "aws_s3_bucket_public_access_block" "loganmarchione_com_block" {
  bucket                  = aws_s3_bucket.loganmarchione_com_resources.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
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

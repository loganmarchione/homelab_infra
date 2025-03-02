################################################################################
### S3
################################################################################

########################################
### Terraform state bucket
########################################

# Create a bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "loganmarchione-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

# Make the bucket private
resource "aws_s3_bucket_acl" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable bucket logging
#resource "aws_s3_bucket_logging" "terraform_state" {
#  bucket = aws_s3_bucket.terraform_state.id
#
#  target_bucket = aws_s3_bucket.terraform_state_logging.id
#  target_prefix = "log/"
#}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "s3_terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id = "30d_move_to_S3_IA_and_1y_delete_old_objects"
    # expire (delete) objects older than 1 year
    noncurrent_version_expiration {
      newer_noncurrent_versions = 10
      noncurrent_days           = 365
    }
    status = "Enabled"
    # transition to STANDARD_ID after 30 days
    noncurrent_version_transition {
      newer_noncurrent_versions = 10
      noncurrent_days           = 30
      storage_class             = "STANDARD_IA"
    }
  }
}

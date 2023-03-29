################################################################################
### Terraform state bucket
################################################################################

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
  # Ignore KICS scan: S3 Bucket Without Enabled MFA Delete
  # Reason: Don't want MFA delete
  # kics-scan ignore-line
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
resource "aws_s3_bucket_logging" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  target_bucket = aws_s3_bucket.loganmarchione_logging.id
  target_prefix = "s3_${aws_s3_bucket.terraform_state.id}/"
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "s3_terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Store Terraform state in a S3 bucket
terraform {
  backend "s3" {
    region  = "us-east-2"
    bucket  = "loganmarchione-terraform-state"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

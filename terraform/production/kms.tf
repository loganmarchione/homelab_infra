resource "aws_kms_key" "s3_bucket_encryption" {
  description         = "KMS key used to encrypt S3 buckets"
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "s3_bucket_encryption" {
  name          = "alias/s3-bucket-encryption"
  target_key_id = aws_kms_key.s3_bucket_encryption.key_id
}

# Store Terraform state in a S3 bucket
terraform {
  backend "s3" {
    region  = "us-east-2"
    bucket  = "loganmarchione-terraform-state"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

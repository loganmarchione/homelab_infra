################################################################################
### AWS
################################################################################

# Default
provider "aws" {
  region                   = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]

  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

# This is needed because CloudFront can only use ACM certs generated in us-east-1
provider "aws" {
  alias                    = "us-east-1"
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

################################################################################
### DigitalOcean
################################################################################

provider "digitalocean" {
  token = var.do_token
}

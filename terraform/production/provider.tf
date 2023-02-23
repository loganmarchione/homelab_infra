###
### AWS
###

# Default
provider "aws" {
  region                   = "us-east-2"
  shared_credentials_files = ["/home/iac/.aws/credentials"]

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

# This is needed because CloudFront can only use ACM certs generated in us-east-1
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/home/iac/.aws/credentials"]
  alias                    = "us-east-1"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

###
### DigitalOcean
###

provider "digitalocean" {
  token = var.do_token
}

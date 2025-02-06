terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.85.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.52.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.48.0"
    }
  }
}

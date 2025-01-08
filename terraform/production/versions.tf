terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.50.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.47.0"
    }
  }
}

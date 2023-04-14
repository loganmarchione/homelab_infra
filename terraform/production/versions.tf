terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.27.0"
    }
  }
}

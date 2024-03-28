terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.36.0"
    }
  }
}

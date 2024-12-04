terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.78.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.45.0"
    }
  }
}

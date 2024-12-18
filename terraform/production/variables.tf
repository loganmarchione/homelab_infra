################################################################################
### Common variables
################################################################################

variable "email_logan" {
  description = "Logan's email address (in secrets.tfvars)"
  sensitive   = true
  type        = string
}

variable "homelab_domain" {
  description = "Homelab domain (in secrets.tfvars)"
  sensitive   = true
  type        = string
}


################################################################################
### AWS variables
################################################################################


################################################################################
### DigitalOcean variables
################################################################################

variable "do_token" {
  description = "DigitalOcean API token (in secrets.tfvars)"
  sensitive   = true
  type        = string
}

# doctl compute region list
variable "do_region" {
  default     = "nyc3"
  description = "Default region"
  type        = string
}

# doctl compute size list
# tflint-ignore: terraform_unused_declarations
variable "do_size" {
  default     = "s-1vcpu-2gb"
  description = "Default droplet size"
  type        = string
}

################################################################################
### Cloudflare
################################################################################

variable "cloudflare_api_token" {
  description = "Cloudflare API token (in secrets.tfvars)"
  sensitive   = true
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID (in secrets.tfvars)"
  sensitive   = true
  type        = string
}

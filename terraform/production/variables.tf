###
### Common variables
###

variable "logan_email" {
  description = "Logan's email address (in secrets.tfvars)"
  sensitive   = true
  type        = string
}

variable "homelab_domain" {
  description = "Homelab domain (in secrets.tfvars)"
  sensitive   = true
  type        = string
}


###
### AWS variables
###


###
### DigitalOcean variables
###

variable "do_token" {
  description = "DigitalOcean API token (in secrets.tfvars)"
  sensitive   = true
  type        = string
}

# doctl compute image list --public
variable "do_image" {
  default     = "debian-11-x64"
  description = "Default OS image"
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


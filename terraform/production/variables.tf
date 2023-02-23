###
### Common variables
###

variable "logan_email" {
  default     = "bG9nYW5AbG9nYW5tYXJjaGlvbmUuY29tCg=="
  description = "Logan's email address (obsfuscated a little so bots won't find it)"
  sensitive   = true
  type        = string
}

variable "homelab_domain" {
  default     = "bG9nYW5tYXJjaGlvbmUueHl6"
  description = "Homelab domain (obsfuscated a little so bots won't find it)"
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
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

# doctl compute image list --public
variable "do_image" {
  description = "Default OS image"
  type        = string
  default     = "debian-11-x64"
}

# doctl compute region list
variable "do_region" {
  description = "Default region"
  type        = string
  default     = "nyc3"
}

# doctl compute size list
# tflint-ignore: terraform_unused_declarations
variable "do_size" {
  description = "Default droplet size"
  type        = string
  default     = "s-1vcpu-2gb"
}


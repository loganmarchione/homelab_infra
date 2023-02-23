resource "digitalocean_droplet" "web01" {
  image      = var.do_image
  name       = "web01.external.loganmarchione.com"
  region     = var.do_region
  size       = "s-1vcpu-1gb"
  ipv6       = "true"
  backups    = "false"
  monitoring = "false"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [image]
  }
}

resource "digitalocean_droplet" "web02" {
  image      = var.do_image
  name       = "web02.external.mariapietropola.com"
  region     = var.do_region
  size       = "s-1vcpu-1gb"
  ipv6       = "true"
  backups    = "false"
  monitoring = "false"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [image]
  }
}

# Print IP address
output "droplet_ip_address_web01" {
  value = digitalocean_droplet.web01.ipv4_address
}

# Print IP address
output "droplet_ip_address_web02" {
  value = digitalocean_droplet.web02.ipv4_address
}

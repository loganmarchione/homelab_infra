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

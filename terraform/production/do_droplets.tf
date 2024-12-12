resource "digitalocean_droplet" "web01" {
  # doctl compute image list --public
  image      = "debian-12-x64"
  name       = "web01.external.mariapietropola.com"
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

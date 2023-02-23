provider "proxmox" {
  pm_api_url  = var.proxmox_host["pm_api_url"]
  pm_user     = var.proxmox_host["pm_user"]
  pm_password = var.pm_password
}

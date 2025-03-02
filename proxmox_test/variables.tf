variable "pm_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_host" {
  description = "Proxmox server info"
  type        = map(any)
  sensitive   = true
  default = {
    "pm_api_url" = "https://proxmox02.internal.mydomain.com:8006/api2/json"
    "pm_node"    = "proxmox02"
    "pm_user"    = "terraform@pve"
    "pm_storage" = "backup_proxmox"
  }
}

resource "proxmox_lxc" "test01" {
  target_node  = var.proxmox_host["pm_node"]
  vmid         = 120
  hostname     = "test01"
  unprivileged = true
  password     = "BasicLXCContainer"
  ostemplate   = "${var.proxmox_host["pm_storage"]}:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  cores  = 3
  memory = 2048

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "dhcp"
    firewall = false
  }

  onboot = true
}

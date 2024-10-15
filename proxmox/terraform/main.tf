terraform {
    required_version = ">= 0.13.0" # Указывает, что требуется версия Terraform не ниже 0.13.0 для использования этой конфигурации.
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = ">= 3.0.1-rc1" # Определяет провайдера Proxmox с указанием источника и версии. Будет скачана версия 2.9.14 или выше провайдера 'telmate/proxmox'.
        }
    }
}

 # Настройки провайдера Proxmox
provider "proxmox" {
  pm_api_url = "https://10.0.0.2:8006/api2/json"
  pm_user = "root@pam"
  pm_password = "ADMsmb456456"
  pm_tls_insecure = true # Игнорирует ошибки SSL-сертификата при подключении к Proxmox (например, если сертификат самоподписанный).
}


variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0kgn6k1dSJqoKiUXv7qqbS9oLtHptlMK58zZTlU8Dm"
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count       = 1
  name        = "tf-vm-1"
  target_node = "anderson"
  clone       = "ubuntu-cloud-base"
  os_type     = "cloud-init"
  cores       = 1
  sockets     = 1
  cpu         = "host"
  memory      = 1024
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  agent       = 1
  ciuser      = "alex"
  cipassword  = "123a"

  disk {
    size    = "20G"
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.10.11/24,gw=192.168.10.1"
  searchdomain = "192.168.10.1"
  nameserver = "192.168.10.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

}

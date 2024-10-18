terraform {
    required_version = ">= 0.13.0" # Указывает, что требуется версия Terraform не ниже 0.13.0 для использования этой конфигурации.
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.1-rc4"# Определяет провайдера Proxmox с указанием источника и версии. Будет скачана версия 2.9.14 или выше провайдера 'telmate/proxmox'.
        }
    }
}

provider "proxmox" {
  pm_api_url = "https://10.10.10.10:8006/api2/json"
  pm_user = "root@pam"
  pm_password = "ADMsmb456456"
  pm_tls_insecure = true # Игнорирует ошибки SSL-сертификата при подключении к Proxmox (например, если сертификат самоподписанный).
}
variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0kgn6k1dSJqoKiUXv7qqbS9oLtHptlMK58zZTlU8Dm"
}




resource "proxmox_vm_qemu" "kube-server" {
  count = 1
  name = "kube-server-0${count.index + 1}"
  target_node = "anderson"
  # thanks to Brian on YouTube for the vmid tip
  # http://www.youtube.com/channel/UCTbqi6o_0lwdekcp-D6xmWw
  vmid = "40${count.index + 1}"

  clone = "ubuntu-cloud-base"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

 disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                   size            = "29900M"
                    storage         = "local-lvm"
                    replicate       = false
                }
            }
        }
    }


#   disk {
#     slot = 0
#     size = "10G"
#     type = "scsi"
#     storage = "local-zfs"
#     #storage_type = "zfspool"
#     iothread = 1
#   }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.98.1.4${count.index + 1}/24,gw=10.98.1.1"
  ipconfig1 = "ip=10.17.0.4${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-agent" {
  count = 2
  name = "kube-agent-0${count.index + 1}"
  target_node = "anderson"
  vmid = "50${count.index + 1}"

  clone = "ubuntu-cloud-base"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"


 disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                   size            = "29900M"
                    storage         = "local-lvm"
                    replicate       = false
                }
            }
        }
    }

#   disk {
#     slot = 0
#     size = "10G"
#     type = "scsi"
#     storage = "local-zfs"
#     #storage_type = "zfspool"
#     iothread = 1
#   }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.98.1.5${count.index + 1}/24,gw=10.98.1.1"
  ipconfig1 = "ip=10.17.0.5${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

# resource "proxmox_vm_qemu" "kube-storage" {
#   count = 1
#   name = "kube-storage-0${count.index + 1}"
#   target_node = "anderson"
#   vmid = "60${count.index + 1}"

#   clone = "ubuntu-cloud-base"

#   agent = 1
#   os_type = "cloud-init"
#   cores = 2
#   sockets = 1
#   cpu = "host"
#   memory = 4096
#   scsihw = "virtio-scsi-pci"
#   bootdisk = "scsi0"


#  disks {
#         ide {
#             ide2 {
#                 cloudinit {
#                     storage = "local-lvm"
#                 }
#             }
#         }
#         scsi {
#             scsi0 {
#                 disk {
#                    size            = "29900M"
#                     storage         = "local-lvm"
#                     replicate       = false
#                 }
#             }
#         }
#     }

# #   disk {
# #     slot = 0
# #     size = "20G"
# #     type = "scsi"
# #     storage = "local-zfs"
# #     #storage_type = "zfspool"
# #     iothread = 1
# #   }

#   network {
#     model = "virtio"
#     bridge = "vmbr0"
#   }
  
#   network {
#     model = "virtio"
#     bridge = "vmbr1"
#   }

#   lifecycle {
#     ignore_changes = [
#       network,
#     ]
#   }

#   ipconfig0 = "ip=10.98.1.6${count.index + 1}/24,gw=10.98.1.1"
#   ipconfig1 = "ip=10.17.0.6${count.index + 1}/24"
#   sshkeys = <<EOF
#   ${var.ssh_key}
#   EOF
# }
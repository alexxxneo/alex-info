terraform {
  required_providers {
    proxmox = {
        source = "telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://10.0.0.2:8006/api2/json"
  pm_user = "root@pam"
  pm_password = "ADMsmb456456"
  pm_tls_insecure = true # Игнорирует ошибки SSL-сертификата при подключении к Proxmox (например, если сертификат самоподписанный).
}

resource "proxmox_vm_qemu" "ubuntu2204" {
    name = "Ununtu2204"
    desc = "A test for using terraform and cloudinit"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "anderson"

    # The template name to clone this vm from
    clone = "ubuntu-cloud-base"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 1
    sockets = 1
    vcpus = 0
    cpu = "host"
    memory = 1024
    scsihw = "virtio-scsi-pci" # в оригинале virtio-scsi-single

    # Setup the disk
    disks {
        ide {
            ide3 {
                cloudinit {
                    storage = "HDD500"
                }
            }
        }
        virtio {
            virtio0 {
                disk {
                    size            = "20G"
                    storage         = "HDD500"
                    replicate       = false
                }
            }
        }
    }

    # Setup the network interface and assign a vlan tag: 256
    network {
        model = "virtio"
        bridge = "vmbr0"
    }

    # Setup the ip address using cloud-init.
    boot = "order=virtio0"
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=dhcp"
    nameserver = "8.8.8.8"
    ciuser = "anderson.a"
}
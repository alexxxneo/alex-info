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
  pm_api_url = "https://10.0.0.2:8006/api2/json"
  pm_user = "root@pam"
  pm_password = "ADMsmb456456"
  pm_tls_insecure = true # Игнорирует ошибки SSL-сертификата при подключении к Proxmox (например, если сертификат самоподписанный).
}
variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0kgn6k1dSJqoKiUXv7qqbS9oLtHptlMK58zZTlU8Dm"
}

resource "proxmox_vm_qemu" "kube-master" {
  count = 1  # Количество виртуалок
  name = "kuber-master${count.index}"  # Имя виртуалки
  target_node = "anderson"  # Узел Proxmox
  vmid = "30${count.index}"  # id для виртуальной машины (например, 301).

  clone = "Ubuntu-24-Template"  # Используется существующий шаблон виртуальной машины для клонирования.
  
  agent = 1  # Включает агент QEMU, который нужен для взаимодействия хоста с гостевой ОС.
  os_type = "cloud-init"  # Указывает тип операционной системы с использованием cloud-init для автоматизации начальной конфигурации.
  cores = 2  # Задаёт количество ядер процессора для виртуальной машины.
  sockets = 1  # Устанавливает количество сокетов процессора (виртуальных CPU).
  cpu = "host"  # Устанавливает тип процессора как "host", что даёт виртуальной машине доступ к возможностям CPU хоста.
  memory = 4096  # Выделяет 4 ГБ оперативной памяти для виртуальной машины.
  scsihw = "virtio-scsi-single"  # Используется контроллер VirtIO SCSI для лучшей производительности диска.
  bootdisk = "scsi0"  # Определяет диск, с которого будет загружаться система (scsi0).
  ciuser      = "ubuntu"  # Устанавливает имя пользователя, которое будет создано в виртуальной машине при помощи cloud-init.
  cipassword  = "123"  # Устанавливает пароль для пользователя 'alex' в виртуальной машине.
  #vm_state = "stopped"  # (Неактивная строка) Можно использовать для создания виртуальной машины в остановленном состоянии.

  disks {  # Описание дисков виртуальной машины.
        ide {
            ide2 {
                cloudinit {  # Указывает, что cloud-init будет использовать диск IDE2.
                    storage = "local-lvm"  # Определяет хранилище для cloud-init в Proxmox.
                }
            }
        }
        virtio {
            virtio0 {  # Описание основного диска, подключённого через контроллер VirtIO.
                disk {
                   size            = "20G"  # Размер основного диска — 20 ГБ.
                    storage         = "local-lvm"  # Хранилище для основного диска в Proxmox.
                    replicate       = false  # Отключает репликацию диска.
                }
            }
        }
    }

  network {  # Первая сетевая карта для доступа узлов из домашней сети.
    model = "virtio"  # Модель сетевой карты — VirtIO (рекомендуется для лучшей производительности).
    bridge = "vmbr0"  # Подключение к сетевому мосту vmbr0 (основной сеть Proxmox).
  }
  
  network {  # Вторая сетевая карта. Сеть для подов
    model = "virtio"  # Модель сетевой карты — VirtIO.
    bridge = "vmbr1"  # Подключение к сетевому мосту vmbr1 (дополнительная сеть, например, для внутренней связи).
  }

  lifecycle {
    ignore_changes = [  # Игнорировать изменения конфигурации сети при повторных применениях Terraform.
      network,
    ]
  }

  ipconfig0 = "ip=10.10.10.1${count.index}/24,gw=10.10.10.1"  # Статическая конфигурация для первой сетевой карты (основная сеть, указание IP и шлюза).
  
  ipconfig1 = "ip=192.168.0.1${count.index}/24"  # Статическая конфигурация для второй сетевой карты (внутренняя сеть).

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}


resource "proxmox_vm_qemu" "kube-agent" {
  count = 2
  name = "kube-agent-0${count.index + 1}"
  target_node = "anderson"
  vmid = "70${count.index + 1}"

  clone = "Ubuntu-24-Template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser      = "ubuntu" # Устанавливает имя пользователя, которое будет создано в виртуальной машине при помощи cloud-init.
  cipassword  = "123" # Устанавливает пароль для пользователя 'kosmonaft' в виртуальной машине.
  #vm_state = "stopped"

 disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        virtio {
            virtio0 {
                disk {
                   size            = "20G"
                    storage         = "local-lvm"
                    replicate       = false
                }
            }
        }
    }


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

  ipconfig0 = "ip=10.10.10.1${count.index+1}/24,gw=10.10.10.1"
  ipconfig1 = "ip=192.168.0.${count.index + 1}/24"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
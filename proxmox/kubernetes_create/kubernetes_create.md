
# Создаем внутреннюю сеть для кубера в проксмокс. Create linux bridge. vmbr1

Для развертывания кластера Kubernetes в Proxmox VE 8.2, необходимо правильно настроить сети для обеспечения связи между узлами и внешним миром. В Proxmox это можно сделать через интерфейс веб-управления или вручную с помощью редактирования конфигурационных файлов. Рассмотрим общие шаги:

### 1. Настройка сетей в Proxmox VE
#### В Proxmox VE сети обычно создаются через `bridge`-интерфейсы. Чтобы развернуть кластер Kubernetes, нужно настроить сеть таким образом, чтобы все виртуальные машины (VM) или контейнеры (LXC) могли взаимодействовать между собой и выходить в интернет.

#### Основные шаги:

#### 1.1. Создание моста (Bridge) для внутренней сети
1. Откройте веб-интерфейс Proxmox.
2. Перейдите в раздел **Datacenter > Node > Network**.
3. Нажмите кнопку **Create > Linux Bridge**.
4. Укажите имя моста, например `vmbr1` (по умолчанию первый мост может быть `vmbr0` — используется для внешнего подключения).
5. Если сеть будет только для внутренней связи между узлами кластера, оставьте поле **Bridge Ports** пустым.
6. Примените изменения.

#### 1.2. Настройка внешней сети (Интернет)
Для доступа узлов к внешней сети, вам нужно настроить bridge с внешним интерфейсом:
1. Используйте уже существующий мост `vmbr0` или создайте новый с указанием в поле **Bridge Ports** физического интерфейса, подключенного к внешней сети, например `enp0s3`.
2. Убедитесь, что для этого моста настроен NAT или имеется выход в интернет через маршрутизатор.

#### Пример конфигурации сетей в `/etc/network/interfaces`:

```bash
auto lo
iface lo inet loopback

auto enp0s3
iface enp0s3 inet manual

auto vmbr0
iface vmbr0 inet static
    address 10.10.10.10/24
    gateway 10.10.10.1
    bridge_ports enp0s3
    bridge_stp off
    bridge_fd 0

auto vmbr1
iface vmbr1 inet static
    address 192.168.0.1/16
    bridge_ports none
    bridge_stp off
    bridge_fd 0
```

- `vmbr0` — внешняя сеть (интернет).
- `vmbr1` — внутренняя сеть для Kubernetes.

### 2. Создание виртуальных машин или контейнеров для Kubernetes
1. Создайте несколько виртуальных машин (VM) или контейнеров (LXC) в Proxmox.
2. Назначьте каждой машине IP-адрес из подсети, связанной с мостом `vmbr1`.
   - Например, для трех узлов кластера Kubernetes можно использовать адреса: `10.0.0.2`, `10.0.0.3`, `10.0.0.4`.

### 3. Настройка статических маршрутов и IP-адресов (опционально)
Для стабильной работы кластера лучше использовать статические IP-адреса для всех узлов.

1. В каждой VM (или контейнере) настройте статические IP-адреса.
2. Пример для VM:
   - Откройте файл `/etc/network/interfaces` внутри VM и настройте статический IP:
     ```bash
     auto eth0
     iface eth0 inet static
         address 10.0.0.2
         netmask 255.255.255.0
         gateway 10.0.0.1
     ```

# Создание шаблона для виртуальной машины в proxmox

```bash
# Устанавливаем необходимые инструменты на сервер Proxmox
apt update # Обновляем информацию о доступных пакетах
apt install -y libguestfs-tools # Устанавливаем libguestfs-tools для работы с образами виртуальных машин

export IMAGES_PATH="/root/template" 
export IMAGE_NAME="noble-server-cloudimg-amd64.img" # имя образа, который будет загружен офф сайта

cd $IMAGES_PATH 
wget https://cloud-images.ubuntu.com/noble/current/${IMAGE_NAME} 


virt-customize --install qemu-guest-agent -a "${IMAGES_PATH}/${IMAGE_NAME}" # Устанавливаем qemu-guest-agent в образ Ubuntu

# настройки машины
export QEMU_CPU_MODEL="host" # Определяем модель процессора для виртуальной машины
export VM_CPU_CORES=2 # Устанавливаем количество ядер процессора для виртуальной машины
export VM_CPU_SOCKETS=1 # Задаем количество процессорных сокетов
export VM_MEMORY=4098 # Устанавливаем объем оперативной памяти (в мегабайтах)
export VM_STORAGE_NAME="local-lvm" # Указываем хранилище, где будут размещаться диски виртуальной машины
export VM_BRIDGE_NAME="vmbr0" # Определяем сетевой мост, который будет использовать виртуальная машина

# Настройки cloud init
export CLOUD_INIT_USER="ubuntu" # Определяем имя пользователя для Cloud-init
export CLOUD_INIT_PASSWORD="123" # Задаем пароль для пользователя
#export CLOUD_INIT_SSHKEY="/home/user/.ssh/id_rsa.pub" # Опционально: можно указать путь к публичному ключу SSH для пользователя
#export CLOUD_INIT_IP="dhcp" # Опционально: можно использовать динамическую настройку IP через DHCP
export CLOUD_INIT_IP="10.10.10.10/24,gw=10.10.10.1" # Задаем статический IP-адрес и шлюз для сети
export CLOUD_INIT_NAMESERVER="8.8.8.8" # Указываем DNS-сервер
export CLOUD_INIT_SEARCHDOMAIN="yandex.ru" # Указываем домен поиска

export TEMPLATE_ID=2001 # Устанавливаем идентификатор шаблона виртуальной машины
#export TEMPLATE_ID=$(pvesh get /cluster/nextid) # Опционально: можно автоматически получить следующий доступный ID

export VM_NAME="Ubuntu-24" # Задаем имя виртуальной машины. _ нельзя использовать в имени
export VM_DISK_IMAGE="${IMAGES_PATH}/${IMAGE_NAME}" # Определяем путь к дисковому образу

# Создаем виртуальную машину с заданной конфигурацией
qm create ${TEMPLATE_ID} --name ${VM_NAME} --cpu ${QEMU_CPU_MODEL} --sockets ${VM_CPU_SOCKETS} --cores ${VM_CPU_CORES} --memory ${VM_MEMORY} --numa 1 --net0 virtio,bridge=${VM_BRIDGE_NAME} --ostype l26 --agent 1 --scsihw virtio-scsi-single

# Импортируем диск
qm set ${TEMPLATE_ID} --virtio0 ${VM_STORAGE_NAME}:0,import-from=${VM_DISK_IMAGE}

# Добавляем привод CD-ROM с Cloud-init, чтобы виртуальная машина могла получать инструкции настройки при загрузке
qm set ${TEMPLATE_ID} --ide2 ${VM_STORAGE_NAME}:cloudinit --boot order=virtio0

# Настраиваем сеть для Cloud-init
qm set ${TEMPLATE_ID} --ipconfig0 ip=${CLOUD_INIT_IP} --nameserver ${CLOUD_INIT_NAMESERVER} --searchdomain ${CLOUD_INIT_SEARCHDOMAIN}

# Настраиваем данные пользователя для Cloud-init
qm set ${TEMPLATE_ID} --ciupgrade 1 --ciuser ${CLOUD_INIT_USER} --cipassword ${CLOUD_INIT_PASSWORD}

# Генерируем ISO-образ Cloud-init, чтобы виртуальная машина инициализировалась с нужными параметрами
qm cloudinit update ${TEMPLATE_ID}

# Устанавливаем имя шаблона для виртуальной машины
qm set ${TEMPLATE_ID} --name "${VM_NAME}-Template"

# Конвертируем виртуальную машину в шаблон
qm template ${TEMPLATE_ID}

```

# Создание terrafrom файла для узлов Kubernetes в proxmox
```conf
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

resource "proxmox_vm_qemu" "kube-server" {
  count = 1  # Количество виртуалок
  name = "kube-server-0${count.index + 1}"  # Имя виртуалки
  target_node = "anderson"  # Узел Proxmox
  vmid = "30${count.index + 1}"  # id для виртуальной машины (например, 301).

  clone = "Ubuntu-24-Template"  # Используется существующий шаблон виртуальной машины для клонирования.
  
  agent = 1  # Включает агент QEMU, который нужен для взаимодействия хоста с гостевой ОС.
  os_type = "cloud-init"  # Указывает тип операционной системы с использованием cloud-init для автоматизации начальной конфигурации.
  cores = 2  # Задаёт количество ядер процессора для виртуальной машины.
  sockets = 1  # Устанавливает количество сокетов процессора (виртуальных CPU).
  cpu = "host"  # Устанавливает тип процессора как "host", что даёт виртуальной машине доступ к возможностям CPU хоста.
  memory = 4096  # Выделяет 4 ГБ оперативной памяти для виртуальной машины.
  scsihw = "virtio-scsi-single"  # Используется контроллер VirtIO SCSI для лучшей производительности диска.
  bootdisk = "scsi0"  # Определяет диск, с которого будет загружаться система (scsi0).
  ciuser      = "alex"  # Устанавливает имя пользователя, которое будет создано в виртуальной машине при помощи cloud-init.
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

  ipconfig0 = "ip=10.10.10.4${count.index + 1}/24,gw=10.10.10.1"  # Статическая конфигурация для первой сетевой карты (основная сеть, указание IP и шлюза).
  
  ipconfig1 = "ip=192.168.0.${count.index + 1}/24"  # Статическая конфигурация для второй сетевой карты (внутренняя сеть).

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
  ciuser      = "alex" # Устанавливает имя пользователя, которое будет создано в виртуальной машине при помощи cloud-init.
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

  ipconfig0 = "ip=10.10.10.4${count.index + 2}/24,gw=10.10.10.1"
  ipconfig1 = "ip=192.168.0.${count.index + 2}/24"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
```


























































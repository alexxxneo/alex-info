# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox

# Определение переменных для подключения к Proxmox API


packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
#если блок не срабатывает и выдает ошибку плагина то устанавливаем вручную 
#packer plugin install github.com/hashicorp/proxmox


# Определение переменной для URL Proxmox API
variable "proxmox_api_url" {
    type = string
    default = "https://10.0.0.2:8006/api2/json"
}

# Определение переменной для идентификатора токена API
variable "proxmox_api_token_id" {
    type = string
    default = "root@pam!packer-token"
}

# Определение переменной для секрета токена API (отмечаем как чувствительное значение)
variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
    default = "4f1fe09d-ab09-4c4f-b6a3-7fd2eafbc489"
}

# Определение ресурса для создания шаблона виртуальной машины (VM Template)
source "proxmox-iso" "ubuntu-server-jammy" {
 
    # Настройки подключения к Proxmox
    proxmox_url = "${var.proxmox_api_url}"  # Используем переменную для указания URL API
    username = "${var.proxmox_api_token_id}"  # Используем переменную для указания ID токена
    token = "${var.proxmox_api_token_secret}"  # Используем переменную для секрета токена (чувствительное значение)

    # (Опционально) Пропустить проверку TLS сертификатов (если используется самоподписанный сертификат)
    insecure_skip_tls_verify = true
    
    # Общие настройки виртуальной машины
    node = "anderson"  # Узел (сервер Proxmox), на котором будет развернута VM
    vm_id = "102"  # Уникальный идентификатор для виртуальной машины
    vm_name = "ubuntu-server-jammy"  # Имя создаваемой виртуальной машины (шаблона)
    template_description = "Ubuntu Server jammy Image"  # Описание шаблона VM

    # Настройки операционной системы виртуальной машины
    # (Вариант 1) Используем локальный ISO файл
     iso_file = "local:iso/jammy-server-cloudimg-amd64.img"
    # - или -
    # (Вариант 2) Загружаем ISO с внешнего URL
    #iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
    #iso_checksum = "9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"  # Контрольная сумма ISO для проверки целостности
    iso_storage_pool = "local"  # Указываем, в каком хранилище Proxmox размещается ISO образ
    unmount_iso = true  # Размонтировать ISO после установки системы

    # Настройки системы VM
    qemu_agent = true  # Включаем QEMU Agent для лучшей интеграции VM с Proxmox (позволяет взаимодействовать с VM из Proxmox)

    # Настройки жёсткого диска виртуальной машины
    scsi_controller = "virtio-scsi-pci"  # Используем контроллер диска VirtIO для лучшей производительности

    # Определение параметров дисков
    disks {
        disk_size = "17G"  # Размер диска VM (в данном случае 20GB)
        format = "raw"  # Формат диска (qcow2 поддерживает снимки (snapshots))
        storage_pool = "local-lvm"  # Хранилище для диска VM (в данном случае LVM на локальном хранилище)
        storage_pool_type = "lvm-thin"  # Тип хранилища (LVM для быстрой работы с виртуальными дисками)
        type = "virtio"  # Тип устройства диска (VirtIO для лучшей производительности)
    }

    # Настройки процессора виртуальной машины
    cores = "2"  # Количество выделяемых процессорных ядер (в данном случае два ядро)

    # Настройки памяти виртуальной машины
    memory = "2048"  # Размер оперативной памяти для виртуальной машины (в данном случае 2GB)

    # Настройки сети для виртуальной машины
    network_adapters {
        model = "virtio"  # Тип сетевого адаптера (VirtIO для лучшей производительности)
        bridge = "vmbr0"  # Используем мостовую сеть (vmbr0 — стандартный мост в Proxmox)
        firewall = "false"  # Отключаем встроенный фаервол Proxmox для этой VM
    } 

    # Настройки Cloud-Init для автоматической конфигурации VM
    cloud_init = true  # Включаем Cloud-Init для автоматической настройки VM при первом запуске
    cloud_init_storage_pool = "local-lvm"  # Хранилище для диска Cloud-Init (в данном случае LVM)

    # Команды для автоматической установки системы через Packer (boot_command)
    boot_command = [
        "<esc><wait>",  # Нажимаем ESC для выхода в меню загрузки
        "e<wait>",  # Редактируем параметры загрузки
        "<down><down><down><end>",  # Переходим в конец строки загрузки
        "<bs><bs><bs><bs><wait>",  # Удаляем ненужные параметры
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",  # Запускаем автоматическую установку с использованием cloud-init (nocloud-net)
        "<f10><wait>"  # Нажимаем F10 для запуска установки
    ]
    boot = "c"  # Устанавливаем режим загрузки с жесткого диска
    boot_wait = "10s"  # Задержка перед загрузкой системы

    # Настройки автоматической установки через Packer
    http_directory = "http"  # Указываем директорию, в которой размещены файлы для автоматической установки

    # (Опционально) Привязываем IP-адрес и порт для сервера HTTP
    # http_bind_address = "0.0.0.0"
    # http_port_min = 8802
    # http_port_max = 8802

    ssh_username = "ubuntu"  # Указываем имя пользователя для SSH-доступа после установки

    # (Вариант 1) Указываем пароль пользователя для SSH-доступа
    #ssh_password = "123"
    # - или -
    # (Вариант 2) Указываем путь к приватному ключу SSH для аутентификации
    ssh_private_key_file = "~/.ssh/id_ed25519"

    # Увеличиваем таймаут для SSH, чтобы учесть время, необходимое для установки системы
    ssh_timeout = "20m"
}

# Определение сборки (build) для создания шаблона VM
build {

    name = "ubuntu-server-jammy"  # Имя сборки
    sources = ["proxmox-iso.ubuntu-server-jammy"]  # Источник для сборки — созданный выше ресурс Proxmox ISO

    # Провиженеры для интеграции Cloud-Init в Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",  # Ожидаем завершения работы cloud-init
            "sudo rm /etc/ssh/ssh_host_*",  # Удаляем SSH ключи для обеспечения безопасности шаблона
            "sudo truncate -s 0 /etc/machine-id",  # Очищаем уникальный идентификатор машины
            "sudo apt -y autoremove --purge",  # Удаляем ненужные пакеты
            "sudo apt -y clean",  # Очищаем кеш пакетов
            "sudo apt -y autoclean",  # Удаляем временные файлы
            "sudo cloud-init clean",  # Очищаем состояние cloud-init
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",  # Удаляем специфичные для установки файлы cloud-init
            "sudo rm -f /etc/netplan/00-installer-config.yaml",  # Удаляем временные сетевые настройки
            "sudo sync"  # Убедиться, что все изменения записаны на диск
        ]
    }

    # Провиженер для интеграции Cloud-Init в Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"  # Файл с дополнительной конфигурацией для Cloud-Init
        destination = "/tmp/99-pve.cfg"  # Копируем файл на временный путь внутри VM
    }

    # Провиженер для интеграции Cloud-Init в Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]  # Копируем файл конфигурации в правильное место
    }
}
    # Добавление дополнительных пров

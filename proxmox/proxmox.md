# Установка proxmox

отключаем в обновлениях использования корпоративного репозитория
там где nosubscribe отключаем - ставим disable

выбираем добавить (add) и выбираем no_subscribe


после установки обязательно добавляем dns сервер 8.8.8.8 и 1.1.1.1 иначе будут проблемы резолвом  и соответственно с загрузкой всех ресурсов 


#  Создание шаблона ubuntu cloud init 22.04 для proxmox через скрипт
Весь процесс выглядит следующим образом:

1. Загрузка Linux Cloud Image нужного дистрибутива.
2. Создание ВМ в Proxmox.
3. При необходимости дополнительная настройка ВМ.
4. Создание шаблона из ВМ.
5. Создание ВМ из шаблона через модуль Proxmox для Terraform.

```bash

# SSH to Proxmox Server
ssh user@your-proxmox-server
su - root

# Install required tools on Proxmox Server
apt update
apt install -y libguestfs-tools

# Install qemu quest agent on Ubuntu 22.04 Cloud Image
export IMAGES_PATH="/mnt/pve/HDD_local" # defines the path where the images will be stored and change the path to it.

cd $IMAGES_PATH

wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

virt-customize --install qemu-guest-agent -a "${IMAGES_PATH}/jammy-server-cloudimg-amd64.img"

export QEMU_CPU_MODEL="host"
export VM_CPU_CORES=2
export VM_CPU_SOCKETS=2
export VM_MEMORY=4098
export VM_STORAGE_NAME="local-lvm"
export VM_BRIDGE_NAME="vmbr0"

export CLOUD_INIT_USER="roman"
export CLOUD_INIT_PASSWORD="Qwerty123"
#export CLOUD_INIT_SSHKEY="/home/user/.ssh/id_rsa.pub" # Provides the path to the SSH public key for the user.
export CLOUD_INIT_IP="dhcp"
# export CLOUD_INIT_IP="192.168.10.20/24,gw=192.168.10.1" # Static example
export CLOUD_INIT_NAMESERVER="8.8.8.8"
export CLOUD_INIT_SEARCHDOMAIN="itproblog.ru"

export TEMPLATE_ID=2001
#export TEMPLATE_ID=$(pvesh get /cluster/nextid)

export VM_NAME="Ubuntu2204"
export VM_DISK_IMAGE="${IMAGES_PATH}/jammy-server-cloudimg-amd64.img"

# Create VM. Change the cpu model 
qm create ${TEMPLATE_ID} --name ${VM_NAME} --cpu ${QEMU_CPU_MODEL} --sockets ${VM_CPU_SOCKETS} --cores ${VM_CPU_CORES} --memory ${VM_MEMORY} --numa 1 --net0 virtio,bridge=${VM_BRIDGE_NAME} --ostype l26 --agent 1 --scsihw virtio-scsi-single

# Import Disk
qm set ${TEMPLATE_ID} --virtio0 ${VM_STORAGE_NAME}:0,import-from=${VM_DISK_IMAGE}

# Add Cloud-Init CD-ROM drive. This enables the VM to receive customization instructions during boot.
qm set ${TEMPLATE_ID} --ide2 ${VM_STORAGE_NAME}:cloudinit --boot order=virtio0

# Cloud-init network-data
qm set ${TEMPLATE_ID} --ipconfig0 ip=${CLOUD_INIT_IP} --nameserver ${CLOUD_INIT_NAMESERVER} --searchdomain ${CLOUD_INIT_SEARCHDOMAIN}

# Cloud-init user-data
qm set ${TEMPLATE_ID} --ciupgrade 1 --ciuser ${CLOUD_INIT_USER} --cipassword ${CLOUD_INIT_PASSWORD}

# Cloud-init regenerate ISO image, ensuring that the VM will properly initialize with the desired parameters.
qm cloudinit update ${TEMPLATE_ID}

qm set ${TEMPLATE_ID} --name "${VM_NAME}-Template"

qm template ${TEMPLATE_ID}
```

# Создание шаблона ubuntu cloud init 22.04 для proxmox в ручном режиме
1. в proxmox'e:
```bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

#создаем виртуальную машину. 9000 это любой idшник
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci --name ubuntu-cloud-base

#импортируем виртуальный диск в хранилище local-lvm
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
# в конце он пишет диск unused0:local-lvm:vm-9000-disk-0  его и используем в следующей команде

qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0 --ide2 local-lvm:cloudinit --boot c -bootdisk scsi0 --serial0 socket --vga serial0 --agent 1
# должны получить  Logical volume "vm-9000-cloudinit" created.
# ide2: successfully created disk 'local-lvm:vm-9000-cloudinit,media=cdrom'
# generating cloud-init ISO
```
2.  меняем настройки cloud init в вебинтерфейсе
3.  запускаем виртуальную машину
4. подсоединяемся по ssh
5.  sudo apt install qemu-guest-agent -y      устанавливаем агент qemu обязательно чтобы наши будущие виртуалки с шаблона работали корректно
6.  редактируем файл sudo nano /etc/cloud/cloud.cfg. Добавляем
```yml
#install packages
package_upgrade: true
packages:
   - qemu-guest-agent
```
7. в proxmos'е конвертуруем в шаблон  
qm template 9000


# Управление через terraform 

если при terraform init выдает ошибку:

"Finding telmate/proxmox versions matching "3.0.0"...
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider telmate/proxmox: no available releases match the
│ given constraints 3.0.0"

то команда terraform provider помогает. Нужно применять многократно


Смотрим актуальную версию proxmox terraform provider
https://github.com/Telmate/terraform-provider-proxmox/releases  
https://registry.terraform.io/providers/Telmate/proxmox/latest


## Особенности при формировании terraform файла
VirtIO-GPU самый стабильный display  
Размер диска у шаблона и в maint.tf должен совпадать, иначе не подцепится  
Размер диска у шаблона можно повышать, но не уменьшать (проще сделать шаблон заново, чем в ручную уменьшать через командную строку)  
В названии шаблона нижние подчеркивания нельзя  
Для общения узлов между собой используется домашняя сеть 10.10.10.10/24  
Для общения подов между собой используется внутренняя сеть 192.168.0.0/16 (т.е. первые 16 бит это адрес сети, остальные это адреса хостов, т.е. диапазон ip для подов выходит 192.168.0.0 - 192.168.255.255)  

































# Перегенерация сертификата для proxmox для добавления адреса

### Перегенерация сертификата через командную строку
1. Откройте терминал и выполните следующую команду для перегенерации сертификата:

   ```bash
   pvecm updatecerts --force
   ```

   Эта команда перегенерирует все сертификаты для всех узлов в кластере Proxmox.

2. Убедитесь, что IP-адрес 10.0.0.2 или любой другой нужный IP включён в сертификат. Чтобы это сделать, добавьте его в файл конфигурации сети:

   - Отредактируйте файл `/etc/hosts` и убедитесь, что IP-адрес 10.0.0.2 ассоциирован с узлом:
   
     ```bash
     10.0.0.2 anderson
     ```

3. После перегенерации сертификатов перезагрузите веб-интерфейс или службу Proxmox:

   ```bash
   systemctl restart pveproxy
   ```

### Отключение проверки сертификатов в Packer
Если же проблема не решается перегенерацией сертификатов, временным решением может стать отключение проверки сертификатов в конфигурации Packer:

1. Откройте файл конфигурации Packer, где указаны параметры подключения к Proxmox.
2. Добавьте опцию:

   ```json
   "tls_skip_verify": true
   ```


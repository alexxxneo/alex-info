# Создание шаблона ubuntu cloud init 22.04 для proxmox
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


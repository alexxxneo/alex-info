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
export CLOUD_INIT_IP="10.10.10.11/24,gw=10.10.10.1" # Задаем статический IP-адрес и шлюз для сети
export CLOUD_INIT_NAMESERVER="8.8.8.8" # Указываем DNS-сервер
export CLOUD_INIT_SEARCHDOMAIN="ya.ru" # Указываем домен поиска

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

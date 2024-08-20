# обозначаем тэгом наш образ
variable "image_tag" {
    type = string
    default = "server-2"
}
 
# источник на базе которого  packer будет строить образ. Пакер запускает виртуальную машину на основе этого образа. Выполняет в следующем пункте все необходимые команды. Делает снимок виртуальной машины, делает образ ОС из этого снимка и загружает его в облако
source "openstack" "nginx"{
    source_image_filter {
        filters {
             name = "ubuntu-20-202404160933.gitd6495fe9" # базовый образ, на основе которого строиться наш кастомный образ
        }
    }
    # Задаем конфигурацию виртуальной машины почти такой же как в terraform, которая будет использоваться для создания образа. После создания образа, она удаляется
    flavor =                    "STD2-1-2"
    ssh_username =              "ubuntu"
    security_groups =           ["default", "ssh+www"]
    volume_size =               10
    volume_availability_zone =  "MS1"
    use_blockstorage_volume =   "true"
    config_drive  =             "true"
    networks =                  ["ec8c610e-6387-447e-83d2-d2c541e88164"]# берем из личного кабинета в разделе сети
    image_name =                "nginx-${var.image_tag}"
}

# Задаем конфигурацию нашего золотого образа
build {
    sources = ["source.openstack.nginx"]
    
    # провизионер bash'a
    provisioner "shell" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt install nginx -y"
        ]
    }
    
    # Как в докере копируем файл из рабочей папки в сборку по указанному пути. Сразу в директорию nginx не можем, т.к она под пользователем root, поэтому перемещаем на следующем шаге
    provisioner "file" {
        source = "index-2.html"
        destination = "/tmp/index.nginx-debian.html"
    }

    # перемещаем в директорию сайта nginx этот html файл
    provisioner "shell" {
        inline = [
            "sudo mv /tmp/index.nginx-debian.html /var/www/html/index.nginx-debian.html"
        ]
    }
}
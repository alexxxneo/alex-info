# получаем id машины с набором ядер и оперативки  по имени, указанному в переменных
data "vkcs_compute_flavor" "compute" {
  name = "STD2-1-2" # Узнать с помощью команды openstack flavor list
}

# получаем id образа ОС по имени образа. 
# data "vkcs_images_image" "server-1" {
#   name = "nginx-server-1" # Узнать с помощью команды openstack image list
# }


data "vkcs_images_image" "server-2" {
  name = "nginx-server-2" # Узнать с помощью команды openstack image list
}

# подключаем существующий ssh ключ, который уже добавлен в облаке
data "vkcs_compute_keypair" "sng" {
  name = "alexanderson"
}

variable "availability_zone_name" {
  type = string
  default = "MS1"
}



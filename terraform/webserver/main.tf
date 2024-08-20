

resource "vkcs_compute_instance" "sng_2" {
  name                    = "sng_2"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  key_pair                = data.vkcs_compute_keypair.sng.id
  security_groups         = ["default", "ssh+www"]
  availability_zone       = var.availability_zone_name
  image_id = data.vkcs_images_image.server-2.id

  block_device {
    uuid                  = data.vkcs_images_image.server-2.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "high-iops"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

   # привязываем ВМ к ранее созданной сети
  network {
    uuid = vkcs_networking_network.sng.id
  }

  #описываем блок зависимостей, т.е. какие ресурсы должны быть созданы перед созданием вирт машины. 
  # Помним что по умолчанию все ресурсы загружаются одновременно
  depends_on = [
    vkcs_networking_network.sng, # указываем что зависит от созданной сети
    vkcs_networking_subnet.sng # указываем что зависит от созданной подсети
  ]
}

# Выделение ресурса floating ip, т.е. плавающего ip, который нам необходим для доступа в интернет. Мы выделяем из пула 1 адрес
resource "vkcs_networking_floatingip" "sng_2" {
  pool = data.vkcs_networking_network.extnet.name
}

# Выполняем привязку нашего плавающего ip к id нашей первой виртуальной машниы, которая должна смотреть в интернет
resource "vkcs_compute_floatingip_associate" "sng_2" {
  floating_ip = vkcs_networking_floatingip.sng_2.address
  instance_id = vkcs_compute_instance.sng_2.id
}


# Получаем уже существующую внешнюю сеть с интернет доступом
data "vkcs_networking_network" "extnet" {
   sdn        = "sprut"
   external   = true
}

# Создаем сеть
resource "vkcs_networking_network" "sng" {
   name       = "sng-net"
 #  sdn        = "sprut"
}
# Создаем подсеть
resource "vkcs_networking_subnet" "sng" {
   name       = "sng-subnet"
   network_id = vkcs_networking_network.sng.id # привязываем подсеть к нашей главной сети
   cidr       = "192.168.199.0/24" # указываем адрес подсети
}

 

# Создаем роутр
resource "vkcs_networking_router" "sng" {
   name       = "sng_router"
 #  sdn        = "sprut"
   external_network_id = data.vkcs_networking_network.extnet.id # привязываем к роутеру внешнюю сеть с доступом в интернет
}

# Подключаем сеть к роутеру
resource "vkcs_networking_router_interface" "sng" {
   router_id  = vkcs_networking_router.sng.id # получаем id роутера
   subnet_id  = vkcs_networking_subnet.sng.id # получаем id подсети
}

 

######### РАБОТАЕМ С БАЛАНСИРОВЩИКОМ НАГРУЗКИ ##########

# #  Создаем балансировщик нагрузки loadbalancer
# resource "vkcs_lb_loadbalancer" "sng" {
#    name = "sng_loadbalancer"
#    vip_subnet_id = "${vkcs_networking_subnet.sng.id}" # указываем к какой подсети он бюдует подключен 
#    tags = ["sng"]
#  }


# # Выделяем внешний ip адрес для loadbalancer
# resource "vkcs_networking_floatingip" "sng_lb" {
#   pool = data.vkcs_networking_network.extnet.name
# }


# # привязываем внешний ip адрес к loadbalancer
# resource "vkcs_networking_floatingip_associate" "lb_fip" {
#   floating_ip =  vkcs_networking_floatingip.sng_lb.address
#   port_id = vkcs_lb_loadbalancer.sng.vip_port_id
# }

### СПИСОК ПРАВИЛ ДЛЯ БАЛАНСИРОВЩИКА НАГРУЗКИ ###

# открываем 80 порт на loadbalancer

# resource "vkcs_lb_listener" "sng_lb" {
#    name = "listener"
#    protocol = "HTTP"
#    protocol_port = 80
#    loadbalancer_id = "${vkcs_lb_loadbalancer.sng.id}"
#  }

# 
# resource "vkcs_lb_pool" "sng" {
#    name = "pool"
#    protocol = "HTTP"
#    lb_method = "ROUND_ROBIN" # указываем протокол балансировки
#    listener_id = "${vkcs_lb_listener.sng_lb.id}" # указываем какие инстансы будут подключены. указываем id инстанса
#  }



# resource "vkcs_lb_member" "sng_2" {
#   address = "${vkcs_compute_instance.sng_2.network.0.fixed_ip_v4}"
#   protocol_port = 80
#   pool_id = "${vkcs_lb_pool.sng.id}"
#   subnet_id = "${vkcs_networking_subnet.sng.id}"
#   weight = 5
# }





# Выводим по окончанию создания ресурсов терраформом адрес плавающего ip
output "instance_fip" {
  value = vkcs_networking_floatingip.sng_2.address
}

В этом Terraform файле, предназначенном для работы с провайдером VKCS описывается процесс создания и настройки инфраструктуры в облаке, включая виртуальные машины, сеть, маршрутизаторы и балансировщик нагрузки. Вот что происходит в этом файле:

### 1. **Создание Виртуальных Машин:**
В этом разделе описывается процесс создания двух виртуальных машин (ВМ).

- **Первая виртуальная машина `sng_1`:**
  ```hcl
  resource "vkcs_compute_instance" "sng_1" {
    name                    = "sng_1"
    flavor_id               = data.vkcs_compute_flavor.compute.id
    key_pair                = data.vkcs_compute_keypair.sng.id
    security_groups         = ["default", "ssh+www"]
    availability_zone       = var.availability_zone_name
    image_id                = data.vkcs_images_image.server-1.id
    ...
  }
  ```
  Здесь создается ВМ с именем `sng_1`. Она получает ресурсы (CPU, RAM) согласно конфигурации, определенной через `flavor_id`. Образ операционной системы выбирается с помощью `image_id`. Также подключается ключ SSH и задаются правила безопасности, позволяющие доступ через SSH и HTTP(S).

- **Вторая виртуальная машина `sng_2`:**
  ```hcl
  resource "vkcs_compute_instance" "sng_2" {
    name                    = "sng_2"
    flavor_id               = data.vkcs_compute_flavor.compute.id
    key_pair                = data.vkcs_compute_keypair.sng.id
    security_groups         = ["default", "ssh+www"]
    availability_zone       = var.availability_zone_name
    image_id                = data.vkcs_images_image.server-2.id
    ...
  }
  ```
  Аналогично создается вторая ВМ `sng_2`, но с другим образом операционной системы. Остальные параметры аналогичны.

- **Блок зависимостей:**
  В обоих случаях указывается, что создание ВМ зависит от создания сети и подсети, что гарантирует их наличие к моменту создания ВМ.

### 2. **Настройка сети:**

- **Создание и настройка сети:**
  ```hcl
  resource "vkcs_networking_network" "sng" {
    name = "sng-net"
  }
  
  resource "vkcs_networking_subnet" "sng" {
    name       = "sng-subnet"
    network_id = vkcs_networking_network.sng.id
    cidr       = "192.168.199.0/24"
  }
  ```
  Создается сеть `sng-net` и подсеть `sng-subnet` с диапазоном IP-адресов `192.168.199.0/24`.

- **Создание и настройка маршрутизатора:**
  ```hcl
  resource "vkcs_networking_router" "sng" {
    name                 = "sng_router"
    external_network_id  = data.vkcs_networking_network.extnet.id
  }
  
  resource "vkcs_networking_router_interface" "sng" {
    router_id = vkcs_networking_router.sng.id
    subnet_id = vkcs_networking_subnet.sng.id
  }
  ```
  Создается маршрутизатор, который подключается к внешней сети и связывает созданную подсеть с интернетом.

### 3. **Назначение плавающих IP-адресов:**

- **Для виртуальных машин:**
  ```hcl
  resource "vkcs_networking_floatingip" "sng_1" {
    pool = data.vkcs_networking_network.extnet.name
  }

  resource "vkcs_compute_floatingip_associate" "sng_1" {
    floating_ip = vkcs_networking_floatingip.sng_1.address
    instance_id = vkcs_compute_instance.sng_1.id
  }
  ```
  Здесь выделяются плавающие IP-адреса для виртуальных машин `sng_1` и `sng_2`, и они привязываются к соответствующим инстансам для доступа из интернета.

### 4. **Настройка Балансировщика Нагрузки (Load Balancer):**

- **Создание балансировщика нагрузки:**
  ```hcl
  resource "vkcs_lb_loadbalancer" "sng" {
    name          = "sng_loadbalancer"
    vip_subnet_id = "${vkcs_networking_subnet.sng.id}"
    tags          = ["sng"]
  }
  ```
  Создается балансировщик нагрузки, подключенный к подсети `sng-subnet`.

- **Выделение и привязка внешнего IP для балансировщика:**
  ```hcl
  resource "vkcs_networking_floatingip" "sng_lb" {
    pool = data.vkcs_networking_network.extnet.name
  }

  resource "vkcs_networking_floatingip_associate" "lb_fip" {
    floating_ip = vkcs_networking_floatingip.sng_lb.address
    port_id     = vkcs_lb_loadbalancer.sng.vip_port_id
  }
  ```
  Выделяется и привязывается внешний IP-адрес к балансировщику нагрузки для обеспечения его доступности извне.

- **Настройка Listener и Pool:**
  ```hcl
  resource "vkcs_lb_listener" "sng_lb" {
    name            = "listener"
    protocol        = "HTTP"
    protocol_port   = 80
    loadbalancer_id = "${vkcs_lb_loadbalancer.sng.id}"
  }

  resource "vkcs_lb_pool" "sng" {
    name        = "pool"
    protocol    = "HTTP"
    lb_method   = "ROUND_ROBIN"
    listener_id = "${vkcs_lb_listener.sng_lb.id}"
  }
  ```
  Настраивается Listener на балансировщике для обработки HTTP-запросов на 80 порту. Pool задает группу серверов, которые будут обрабатывать запросы, распределяя их с помощью метода `ROUND_ROBIN`.

- **Добавление членов в Pool:**
  ```hcl
  resource "vkcs_lb_member" "sng_1" {
    address       = "${vkcs_compute_instance.sng_1.network.0.fixed_ip_v4}"
    protocol_port = 80
    pool_id       = "${vkcs_lb_pool.sng.id}"
    subnet_id     = "${vkcs_networking_subnet.sng.id}"
    weight        = 5
  }

  resource "vkcs_lb_member" "sng_2" {
    address       = "${vkcs_compute_instance.sng_2.network.0.fixed_ip_v4}"
    protocol_port = 80
    pool_id       = "${vkcs_lb_pool.sng.id}"
    subnet_id     = "${vkcs_networking_subnet.sng.id}"
    weight        = 5
  }
  ```
  В Pool добавляются созданные виртуальные машины `sng_1` и `sng_2`, каждая из которых будет обрабатывать HTTP-запросы на 80 порту.

### 5. **Вывод результата:**

- **Output:**
  ```hcl
  output "instance_fip" {
    value = vkcs_networking_floatingip.sng_lb.address
  }
  ```
  В конце Terraform конфигурации выводится внешний IP-адрес балансировщика нагрузки, который можно использовать для доступа к сервисам, размещенным на созданных виртуальных машинах через балансировщик.

### **Заключение:**
Этот Terraform файл автоматизирует создание целой инфраструктуры в облаке VKCS, включая виртуальные машины, сеть, маршрутизаторы, плавающие IP-адреса и балансировщик нагрузки. Вся инфраструктура настраивается таким образом, чтобы обеспечить доступность и распределение нагрузки между виртуальными машинами, что полезно для создания отказоустойчивых и масштабируемых веб-приложений.
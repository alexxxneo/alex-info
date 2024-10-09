

# Динамический блок

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092", "9093"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  # Жизненный цикл lifecycle

защищает ресурс от уничтожения. Например такое важно чтобы не убить базу данных
    lifecycle {
        prevent_destroy = true
  }

Сначала создает ресурс в который мы добавляем эту опцию, а потом убивает старый
    lifecycle {
    create_before_destroy = true
  }

Игнорирует изменения в указанных параметрах. Если что-то поменяем в них, то терраформ не увидит этих изменения
    lifecycle {
        ignore_changes = ["security_groups", "key_pair"]
  }

# Подключение скриптов

в терраформе:
```t
user_data = templatefile("user_data.sh.tpl", {
    f_name = "Denis",
    l_name = "Astahov",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Lena", "Katya"]
  })
  user_data_replace_on_change = true # Added in the new AWS provider!!!
```

```bash

#!/bin/bash
yum -y update
yum -y install httpd


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v0.12</font></h2><br>
Owner ${f_name} ${l_name} <br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

sudo service httpd start
chkconfig httpd on

```

Тестировать скрипты мы можем введя команду  terraform console





# Packer от хашикорп для упакови образов и отправки через openstack в vk cloud

## Вариант1
Устанавливаем ключ и удаляем старые записи от hashicorp в /etc/apt/sources.list.d  

``` bash 
sudo -s
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg  

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
apt update  

packer plugins install github.com/hashicorp/openstack

#Устанавливаем Packer  
sudo apt-get update && sudo apt-get install packer
```
##  Вариант2

Взять бинарник с зеркала vk
https://hashicorp-releases.mcs.mail.ru/packer/

packer plugins install github.com/hashicorp/openstack

## Использование Packer с vk cloud
+ Создаем файлы из папки packer.
+ packer build nginx1.pkr.hcl Запускаем команду создания образа. Пакер запускает виртуальную машину на основе этого образа в облаке. Выполняет все необходимые команды. Делает снимок виртуальной машины, делает образ ОС из этого снимка и загружает его в облаке в раздел образы. Доступ идет через наши api данные из личного кабинета. По тем же данным что и работает openstack

packer build nginx2.pkr.hcl   запуск создания образа

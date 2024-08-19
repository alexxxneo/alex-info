

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
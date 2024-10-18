

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


# Настройка .gitignore файла для Terraform проектов

При работе с Terraform проектами важно правильно настроить файл `.gitignore`, чтобы исключить из версионного контроля файлы, содержащие чувствительные данные или файлы, которые генерируются автоматически и не должны храниться в репозитории. В этой статье мы рассмотрим пример .gitignore файла для Terraform проектов и объясним каждую его секцию.

## Пример .gitignore файла

```plaintext
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# terraform lockfile
.terraform.lock.hcl

# Crash log files
crash.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version
# control as they are data points which are potentially sensitive and subject
# to change depending on the environment.
*.tfvars

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
#!example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc
```

### Разбор содержимого .gitignore

#### Исключение локальных директорий .terraform

```plaintext
**/.terraform/*
```
Этот шаблон исключает все локальные директории `.terraform`, которые содержат временные файлы и кэшированные данные, используемые Terraform для хранения состояния и конфигураций.

#### Исключение файлов состояния (.tfstate)

```plaintext
*.tfstate
*.tfstate.*
```
Файлы состояния Terraform (`.tfstate`) содержат информацию о текущем состоянии инфраструктуры, управляемой Terraform. Эти файлы часто содержат чувствительные данные и не должны быть добавлены в систему контроля версий.

#### Исключение файлов блокировки Terraform

```plaintext
.terraform.lock.hcl
```
Файл блокировки Terraform (`.terraform.lock.hcl`) обеспечивает детерминированность версий провайдеров. Этот файл может быть специфичным для локальной машины и не должен храниться в репозитории.

#### Исключение файлов с логами ошибок

```plaintext
crash.log
```
Файл с логами ошибок (`crash.log`) генерируется в случае краха Terraform и не должен храниться в системе контроля версий.

#### Исключение файлов переменных (.tfvars)

```plaintext
*.tfvars
```
Файлы переменных (`.tfvars`) часто содержат чувствительные данные, такие как пароли и приватные ключи, и не должны быть добавлены в репозиторий.

#### Исключение файлов переопределения

```plaintext
override.tf
override.tf.json
*_override.tf
*_override.tf.json
```
Файлы переопределения используются для локальных изменений ресурсов и обычно не должны быть включены в систему контроля версий.

#### Включение файлов переопределения с отрицательным шаблоном

```plaintext
#!example_override.tf
```
Эта строка показывает, как можно включить конкретные файлы переопределения в систему контроля версий, используя отрицательный шаблон.

#### Исключение файлов плана Terraform

```plaintext
# example: *tfplan*
```
Файлы плана (`tfplan`) содержат результаты выполнения команды `terraform plan` и не должны храниться в репозитории.

#### Исключение конфигурационных файлов CLI

```plaintext
.terraformrc
terraform.rc
```
Конфигурационные файлы Terraform CLI (`.terraformrc` и `terraform.rc`) могут содержать локальные настройки и не должны храниться в системе контроля версий.

## Заключение

Правильная настройка файла `.gitignore` для Terraform проектов помогает избежать добавления в репозиторий временных файлов, данных состояния и других файлов, которые могут содержать чувствительную информацию. Использование этого примера .gitignore файла поможет вам защитить ваши данные и упростить управление версиями в Terraform проектах.
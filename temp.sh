#!/bin/bash
# удаление php 
# sudo apt purge 'php8.3*'


# установка php 7.2 для laravel 5.5



sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update && sudo apt install -y php7.2 php7.2-mbstring php7.2-xml php7.2-bcmath php7.2-zip curl unzip php7.2-gd php7.2-curl php7.2-json php7.2-mysql php7.2-sqlite3


# раскомментировать extension=gd2 в sudo nano /etc/php/7.2/fpm/php.ini



 #composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

cd /var/www/html

composer create-project october/october octobercms

sudo chown -R www-data:www-data /var/www/html/octobercms
sudo chmod -R 775 /var/www/html/octobercms/storage
sudo chmod -R 775 /var/www/html/octobercms/bootstrap/cache



# отключаем стандартную конфигурацию nginx 
sudo rm /etc/nginx/sites-enabled/default

#копируем новую конфигурацию nginx для october
# sudo nano /etc/nginx/sites-available/october

# активируем новую конфигурацию и перезагружаем nginx
sudo ln -s /etc/nginx/sites-available/october /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Установка mysql
sudo apt install -y mysql-server

sudo mysql -u root -p

CREATE DATABASE sambiaho_sambia;
CREATE USER 'sambiaho_last'@'localhost' IDENTIFIED BY 'adm456456';
GRANT ALL PRIVILEGES ON sambiaho_sambia.* TO 'sambiaho_last'@'localhost';
ALTER USER 'sambiaho_last'@'localhost' IDENTIFIED WITH mysql_native_password BY 'adm456456';
FLUSH PRIVILEGES;
EXIT;

# импортируем БД
mysql -u sambiaho_last -p sambiaho_sambia < ~sambiaho_sambia.sql



# переключение между php версиями
#sudo apt-get install -y php-switch
#php-switch 7.4


#установка virtual box https://gcore.com/learning/how-to-install-virtualbox-on-ubuntu/
sudo apt update
$ curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > oracle_vbox_2016.gpg
$ curl https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > oracle_vbox.gpg
$ sudo install -o root -g root -m 644 oracle_vbox_2016.gpg /etc/apt/trusted.gpg.d/
$ sudo install -o root -g root -m 644 oracle_vbox.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
sudo apt install virtualbox-7.0 -y
wget https://download.virtualbox.org/virtualbox/7.0.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack
wget https://download.virtualbox.org/virtualbox/7.0.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack

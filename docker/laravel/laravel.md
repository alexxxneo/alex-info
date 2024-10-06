
ci/cd для octobercms (laravel)

<!-- TOC -->

- [Develop окружение](#develop-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5)
    - [Создаем docker-compose.devtest.yml](#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%B5%D0%BC-docker-composedevtestyml)
    - [Создаем docker-compose.dev.yml](#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%B5%D0%BC-docker-composedevyml)
    - [Создаем Dockerfile для прода](#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%B5%D0%BC-dockerfile-%D0%B4%D0%BB%D1%8F-%D0%BF%D1%80%D0%BE%D0%B4%D0%B0)
- [Prod окружение](#prod-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5)
    - [Создаем .gitlabci.yml](#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%B5%D0%BC-gitlabciyml)
- [Весь процесс. Check list:](#%D0%B2%D0%B5%D1%81%D1%8C-%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D1%81%D1%81-check-list)
- [Используемые команды и важные действия](#%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D1%83%D0%B5%D0%BC%D1%8B%D0%B5-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B-%D0%B8-%D0%B2%D0%B0%D0%B6%D0%BD%D1%8B%D0%B5-%D0%B4%D0%B5%D0%B9%D1%81%D1%82%D0%B2%D0%B8%D1%8F)
    - [особенности](#%D0%BE%D1%81%D0%BE%D0%B1%D0%B5%D0%BD%D0%BD%D0%BE%D1%81%D1%82%D0%B8)
    - [Используемые команды](#%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D1%83%D0%B5%D0%BC%D1%8B%D0%B5-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B)
        - [docker команды](#docker-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B)
        - [git команды](#git-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B)
- [Gitlab переменные](#gitlab-%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5)
        - [CI/CD Pipeline и Job переменные](#cicd-pipeline-%D0%B8-job-%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5)
        - [Переменные проекта](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B0)
        - [Переменные окружения и runner'ов](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F-%D0%B8-runner%D0%BE%D0%B2)
        - [Переменные пользователя](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F)
        - [Переменные окружения для Docker и Kubernetes](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F-%D0%B4%D0%BB%D1%8F-docker-%D0%B8-kubernetes)
        - [Переменные для деплоя](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%B4%D0%BB%D1%8F-%D0%B4%D0%B5%D0%BF%D0%BB%D0%BE%D1%8F)
        - [Переменные сборки и артефактов](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D1%81%D0%B1%D0%BE%D1%80%D0%BA%D0%B8-%D0%B8-%D0%B0%D1%80%D1%82%D0%B5%D1%84%D0%B0%D0%BA%D1%82%D0%BE%D0%B2)
    - [добавляем модуль php-fpm](#%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D0%BC-%D0%BC%D0%BE%D0%B4%D1%83%D0%BB%D1%8C-php-fpm)
    - [Установка composer](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-composer)
- [nginx.conf теперь имеет вид](#nginxconf-%D1%82%D0%B5%D0%BF%D0%B5%D1%80%D1%8C-%D0%B8%D0%BC%D0%B5%D0%B5%D1%82-%D0%B2%D0%B8%D0%B4)
- [docker-compose теперь имеет вид](#docker-compose-%D1%82%D0%B5%D0%BF%D0%B5%D1%80%D1%8C-%D0%B8%D0%BC%D0%B5%D0%B5%D1%82-%D0%B2%D0%B8%D0%B4)
- [добавляем mysql](#%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D0%BC-mysql)
- [October](#october)
        - [Переменные базы данных:](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%B1%D0%B0%D0%B7%D1%8B-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85)
        - [Переменные для окружения Laravel/October CMS:](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%B4%D0%BB%D1%8F-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F-laraveloctober-cms)
        - [Переменные для управления GitLab CI/CD:](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%B4%D0%BB%D1%8F-%D1%83%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D1%8F-gitlab-cicd)
        - [Переменные для кэширования по желанию:](#%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%B4%D0%BB%D1%8F-%D0%BA%D1%8D%D1%88%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F-%D0%BF%D0%BE-%D0%B6%D0%B5%D0%BB%D0%B0%D0%BD%D0%B8%D1%8E)
        - [Дополнительные переменные для развертывания:](#%D0%B4%D0%BE%D0%BF%D0%BE%D0%BB%D0%BD%D0%B8%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B5-%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5-%D0%B4%D0%BB%D1%8F-%D1%80%D0%B0%D0%B7%D0%B2%D0%B5%D1%80%D1%82%D1%8B%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F)
- [доп инфо](#%D0%B4%D0%BE%D0%BF-%D0%B8%D0%BD%D1%84%D0%BE)

<!-- /TOC -->

## Установка базового ПО для трех окружений. Git, Docker и Gitlab runners
Настраиваем 3 окружения: локалка, 2 виртуалки: develop и prod и на все устанавливаем git, docker и gitlab runners

## Установка Docker

```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done # удаляем конфликтующие пакеты

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER #
# перезагружаем систему
```

## Установка Gitlab-runners

Создаем новые раннеры в гитлабе самом сначала, прописываем нужные теги: local, develop, prod
Установка самих раннеров, УСТАНАВЛИВАЕМ ВСЕ ЧЕРЕЗ SUDO:

```bash
sudo curl -L --output /usr/local/bin/gitlab-runner "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64"

sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

sudo rm -rf /etc/systemd/system/gitlab-runner.service
sudo gitlab-runner install --user=root

sudo gitlab-runner start

# только сначала создаем раннер для проекта в разделе настройки cicd runners
sudo gitlab-runner register  --url https://gitlab.com  --token glrt-2tz3SnQJmHTtdntAjsUn
#для develop 
sudo gitlab-runner register  --url https://gitlab.com  --token glrt-4RMfwMf4xx9t4_e1A_eu

sudo gitlab-runner restart

```

## Настройка локального окружения. docker-сompose.yml

## Создание docker-compose.yml

```yml
# version: '3'

services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ #  прокидываем папку с проектом в контейнер с nginx 
      - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - 8080:80
    container_name: sambia_nginx
    depends_on:
      - app
    networks:
      - app_network            # Сеть для взаимодействия с PHP 
 
  app:
    # image: php:7.2-fpm
    build: # при запуске docker compose собирается image на базе php:7.2-fpm, туда устанавливаются дополнения для php, копируется проект
      context: .
      dockerfile: _docker/app/Dockerfile
    working_dir: /var/www/
    environment:
      - MYSQL_HOST=db          # Имя сервиса базы данных
      - MYSQL_PORT=3306        # Порт для MySQL
      - MYSQL_DATABASE=sambiaho_sambia # Имя базы данных
      - MYSQL_USER=sambiaho_last    # Пользователь базы данных
      - MYSQL_PASSWORD=adm456456 # Пароль пользователя базы данных
    volumes:
      - ./:/var/www
    container_name: sambia_app
    depends_on:
      - db
    networks:
      - app_network            # Сеть для взаимодействия с PHP
    
  db:
    image: mysql:5.7
    restart: always # если контейнер упал, то докер его перезапускает
    volumes:
      - db_data:/var/lib/mysql     # Том для хранения данных базы данных
      - ./db/backup.sql:/docker-entrypoint-initdb.d/backup.sql # Восстанавливаем базу данных из дампа при первом запуске
    #  - ./tmp/db:/var/lib/mysql # стандартный путь для mysql /var/lib/mysql
    environment:
      - MYSQL_HOST=db          # Имя сервиса базы данных
      - MYSQL_PORT=3306        # Порт для MySQL
      - MYSQL_DATABASE=sambiaho_sambia # Имя базы данных
      - MYSQL_USER=sambiaho_last    # Пользователь базы данных
      - MYSQL_PASSWORD=adm456456 # Пароль пользователя базы данных
      - MYSQL_ROOT_PASSWORD=root
    ports:
      - 3333:3306
    #command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    container_name: sambia_db
    networks:
      - app_network            # Сеть для взаимодействия с PHP

volumes:
  db_data:  # Том для хранения данных MySQL

networks:
  app_network:  # Сеть для взаимодействия сервисов
  
```

## Создание Dockerfile:

```dockerfile
FROM php:7.2-fpm

RUN apt update && apt-get install -y \
      apt-utils \
      libpq-dev \
      libpng-dev \
      libzip-dev \
      zip unzip \
      git && \
      docker-php-ext-install pdo_mysql && \
      docker-php-ext-install bcmath && \
      docker-php-ext-install gd && \
      docker-php-ext-install zip && \
      apt-get clean && \
      # php7.2 php7.2-mbstring php7.2-xml php7.2-bcmath php7.2-zip curl unzip php7.2-gd php7.2-curl php7.2-json php7.2-mysql php7.2-sqlite3 && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#копируем php.ini
COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

# копируем все файлы проекта в рабочую директорию исключая указанные в .dockerignore 
COPY --chown=root:www-data --chmod=775 . .

# Настраиваем права доступа для веб-сервера
#RUN chown -R www-data:www-data /var/www/storage
# RUN composer dump-autoload  --no-scripts --optimize && \
# RUN chown -R root:www-data /var/www && \
#     chmod -R 775 /var/www && \
#     chmod -R 775 /var/www/storage 


#COPY composer.*  ./

#Install composer
 ENV COMPOSER_ALLOW_SUPERUSER=1
 RUN curl -sS https://getcomposer.org/installer | php -- \
    --filename=composer \
    --install-dir=/usr/local/bin
# alias
RUN echo "alias a='artisan'" >> /root/.bashrc


#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
#RUN apt-get install -y nodejs
    
# Настраиваем рабочий процесс для Nginx
#CMD ["php-fpm"]
```

## Копируем php.ini

```conf
cgi.fix_pathinfo=0
max_execution_time = 1000
max_input_time = 1000
memory_limit=4G
```


## создаем nginx config
Создаем базовый конфиг nginx.conf в nginx/conf.d/nginx.conf
```conf

server {
    root /var/www/;

    location / {
        try_files $uri /index.php;
        # kill cache
        add_header Last-Modified $date_gmt;
        add_header Cache-Control 'no-store, no-cache';
        if_modified_since off;
        expires off;
        etag off;
    }
  

    location ~ \.php$ {  # Обрабатываем все запросы к PHP-файлам
        try_files $uri =404;  # Проверяем наличие файла, если файл не найден - возвращаем 404 ошибку
        fastcgi_split_path_info ^(.+\.php)(/.+)$;  # Разбиваем URL на два компонента: путь к PHP-файлу и дополнительную информацию (PATH_INFO)
    # ВНИМАНИЕ тут указываем как и имя сервиса app в docker compose
        fastcgi_pass app:9000;  # Передаем запрос PHP-FPM, работающему на сокете php:9000
        fastcgi_index index.php;  # Устанавливаем index.php как индексный файл для директорий
        include fastcgi_params;  # Включаем стандартные параметры FastCGI для передачи на PHP-FPM
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # Указываем полный путь к PHP-файлу на сервере
        fastcgi_param PATH_INFO $fastcgi_path_info;  # Передаем переменную PATH_INFO, которая содержит дополнительную информацию после имени PHP-файла
    }
}

    # тестовая страница по другому пути
    # location /asd {
    #     try_files $uri /asd.html;
    # }
```
а так же создаем php.ini
```conf

```







# Develop окружение

Dockerfile используем тот же что и для девокружения
## Создаем docker-compose.devtest.yml 
без использования gitlab переменных для тестирования

```yml

services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ # прокидываем сайт
      - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - 80:80
    container_name: sambia_nginx
    depends_on:
      - app
    networks:
      - app_network            # Сеть для взаимодействия с PHP
 
  app:
    image: sambia-app
    # build:
    #   context: .
    #   dockerfile: _docker/app/Dockerfile
    working_dir: /var/www/
    #command: ["sh", "-c",  "chown -R root:www-data /var/www && chmod 755 -R /var/www && chmod -R 775 /var/www/storage && php-fpm"] 
    environment:
      - MYSQL_HOST=db          # Имя сервиса базы данных
      - MYSQL_PORT=3306        # Порт для MySQL
      - MYSQL_DATABASE=sambiaho_sambia # Имя базы данных
      - MYSQL_USER=sambiaho_last    # sПользователь базы данных
      - MYSQL_PASSWORD=adm456456 # Пароль пользователя базы данных
    #volumes: # пробрасывать сайт при отправке на дев или прод не нужно. Весь проект в образе
    #  - ./:/var/www
    depends_on:
      - db
    container_name: sambia_app
    networks:
      - app_network            # Сеть для взаимодействия с PHP
    
  db:
    image: mysql:5.7
    restart: always # если контейнер упал, то докер его перезапускает
    volumes:
      - db_data:/var/lib/mysql     # Том для хранения данных базы данных
      - ./db/backup.sql:/docker-entrypoint-initdb.d/backup.sql # Восстанавливаем базу данных из дампа при первом запуске
    #  - ./tmp/db:/var/lib/mysql # стандартный путь для mysql /var/lib/mysql
    environment:
      - MYSQL_HOST=db          # Имя сервиса базы данных
      - MYSQL_PORT=3306        # Порт для MySQL
      - MYSQL_DATABASE=sambiaho_sambia # Имя базы данных
      - MYSQL_USER=sambiaho_last    # Пользователь базы данных
      - MYSQL_PASSWORD=adm456456 # Пароль пользователя базы данных
      - MYSQL_ROOT_PASSWORD=root
    ports:
      - 3306:3306
    #command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    container_name: sambia_db
    networks:
      - app_network            # Сеть для взаимодействия с PHP

volumes:
  db_data:  # Том для хранения данных MySQL

networks:
  app_network:  # Сеть для взаимодействия сервисов
  
```
## Создаем docker-compose.dev.yml

Тестируем его на дев стенде

```yml
services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ # прокидываем сайт
      - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - 80:80
    container_name: sambia_nginx
    depends_on:
      - app
    networks:
      - app_network            # Сеть для взаимодействия с PHP
 
  app:
    image: $REGISTRY/dev/app:$CI_COMMIT_SHA
    # build:
    #   context: .
    #   dockerfile: _docker/app/Dockerfile
    working_dir: /var/www/
    #command: ["sh", "-c",  "chown -R root:www-data /var/www && chmod 755 -R /var/www && chmod -R 775 /var/www/storage && php-fpm"] 
    environment:
      - MYSQL_HOST=${DB_HOST}          # Имя сервиса базы данных
      - MYSQL_PORT=3306       
      - MYSQL_DATABASE=${DB_DATABASE} 
      - MYSQL_USER=${DB_USERNAME}    
      - MYSQL_PASSWORD=${DB_PASSWORD} 
    #volumes: # пробрасывать сайт при отправке на дев или прод не нужно. Весь проект в образе
    #  - ./:/var/www
    depends_on:
      - db
    container_name: ${CONTAINER_PREFIX}_app
    networks:
      - app_network            # Сеть для взаимодействия с PHP
    
  db:
    image: mysql:5.7
    restart: always # если контейнер упал, то докер его перезапускает
    volumes:
      - db_data:/var/lib/mysql     # Том для хранения данных базы данных
      - ./db/backup.sql:/docker-entrypoint-initdb.d/backup.sql # Восстанавливаем базу данных из дампа при первом запуске
    #  - ./tmp/db:/var/lib/mysql # стандартный путь для mysql /var/lib/mysql
    environment:
      - MYSQL_HOST=${DB_HOST}          # Имя сервиса базы данных - db  в нашем случае
      - MYSQL_PORT=3306  
      - MYSQL_DATABASE=${DB_DATABASE} 
      - MYSQL_USER=${DB_USERNAME}
      - MYSQL_PASSWORD=${DB_PASSWORD}
      - MYSQL_ROOT_PASSWORD={DB_ROOT_PASSWORD}
    ports:
      - 3306:3306
    #command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    container_name: ${CONTAINER_PREFIX}_db
    networks:
      - app_network            # Сеть для взаимодействия с PHP

volumes:
  db_data:  # Том для хранения данных MySQL

networks:
  app_network:  # Сеть для взаимодействия сервисов
  
```
## Создаем Dockerfile для прода
 в ./_docker/app/gitlab/Dockerfile


 ```dockerfile
FROM php:7.2-fpm

RUN apt update && apt-get install -y \
      apt-utils \
      libpq-dev \
      libpng-dev \
      libzip-dev \
      zip unzip \
      git && \
      docker-php-ext-install pdo_mysql && \
      docker-php-ext-install bcmath && \
      docker-php-ext-install gd && \
      docker-php-ext-install zip && \
      apt-get clean && \
      # php7.2 php7.2-mbstring php7.2-xml php7.2-bcmath php7.2-zip curl unzip php7.2-gd php7.2-curl php7.2-json php7.2-mysql php7.2-sqlite3 && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#копируем php.ini
COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

# копируем все файлы проекта в рабочую директорию исключая указанные в .dockerignore 
COPY --chown=root:www-data --chmod=775 . .

# Настраиваем права доступа для веб-сервера
#RUN chown -R www-data:www-data /var/www/storage
# RUN composer dump-autoload  --no-scripts --optimize && \
# RUN chown -R root:www-data /var/www && \
#     chmod -R 775 /var/www && \
#     chmod -R 775 /var/www/storage 


#COPY composer.*  ./

#Install composer
 ENV COMPOSER_ALLOW_SUPERUSER=1
 RUN curl -sS https://getcomposer.org/installer | php -- \
    --filename=composer \
    --install-dir=/usr/local/bin
# alias
RUN echo "alias a='artisan'" >> /root/.bashrc


#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
#RUN apt-get install -y nodejs
    
# Настраиваем рабочий процесс для Nginx
#CMD ["php-fpm"]


```



# Prod окружение
На проде используем  docker-compose.prod.yml - почти такой же как и в прошлый раз для дев среды, добавляются только прод переменные

## Создаем .gitlabci.yml

```yml
# Определяем этапы, которые будут выполняться в процессе CI/CD
stages:
  - build # стадия билда нашего образа
  - deploy  # стадия деплоя

# Создаем переменные окружения для использования в других частях конфигурации
variables:
  REGISTRY: "registry.gitlab.com/sambia1/sambia-small"  # URL реестра Docker в гитлабе

# Команды, которые выполняются перед выполнением каждого этапа в stages
before_script:
  # Входим в Docker реестр, используя переменные GitLab для аутентификации
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

# Определяем задачу для сборки приложения
app_build:
  stage: build  # Указываем, что задача относится к этапу сборки
  tags:
    - build  # Указываем тег для выполнения на гитлаб раннере с тегом build на сервере
  only:
    - develop  # Задача выполняется только для ветки 'develop'
    - tags # деплой при создании тега (релиза для мастер ветки)
  
  # Команды, которые будут выполняться в рамках этой задачи
  script:
    # Сборка Docker-образа с передачей аргумента NODE_ENV. в теге указываем переменные чтобы гитлаб смог забирать последнюю актуальную версию нашего образа
    - docker build --build-arg NODE_ENV="dev" -t "$REGISTRY/dev/app:$CI_COMMIT_SHA" -f ./_docker/app/gitlab/Dockerfile .
    # Публикация собранного образа в реестр Docker 
    - docker push "$REGISTRY/dev/app:$CI_COMMIT_SHA"

app_deploy:
  stage: deploy
  tags:
    - develop # запускаем задачу на раннере с тегом develop
  only:
    - develop # деплой при коммите в девелоп ветку
  script:
    - export CONTAINER_PREFIX=sambia
    # 1 вариант - самый краткий. Остановка и удаление всех контейнеров и томов, а так образов
    - docker compose -f docker-compose.prod.yml down --volumes --rmi all # остановка  контейнеров и удаление всех ресурсов относящихся к этому файлу docker-compose.prod.yml
    - docker compose -p $CONTAINER_PREFIX -f docker-compose.prod.yml up -d # запуск нового, нетронутого предыдущим шагом образа, а так же создание остальных ресурсов
    - docker system prune -a -f # очистка всех НЕИСПОЛЬЗУЕМЫХ ресурсов на всякий случай, включая образы, сети, тома 

    # 2 вариант -  остановка и удаления всех контейнеров включая все остановленные и томов по префиксу 
    # - docker stop $(docker ps -a | grep ${CONTAINER_PREFIX}_ | awk '{print $1}') || true
    # - docker rm $(docker ps -a | grep ${CONTAINER_PREFIX}_ | awk '{print $1}') || true
    # - docker volume rm $(docker volume ls | grep ${CONTAINER_PREFIX}_ | awk '{print $2}') || true
    
    # 3 вариант - удаление по фильтру префикса. Выполняем удаление всех ресурсов и контейнеров в докере
    # - docker stop $(docker ps -a -q --filter "name=${CONTAINER_PREFIX}_") || true
    # - docker rm $(docker ps -a -q --filter "name=${CONTAINER_PREFIX}_") || true
    # - docker volume rm $(docker volume ls -q --filter "name=${CONTAINER_PREFIX}_") || true
    
    #- docker network rm $(docker network ls -q --filter "name=${CONTAINER_PREFIX}_") || true
    #- docker rmi $(docker images -q --filter "reference=${CONTAINER_PREFIX}_*") || true


    #- docker exec sambia_app chown -R root:www-data /var/www && chmod 755 -R /var/www && chmod -R 775 /var/www/storage 
    
    # - docker exec ${CONTAINER_PREFIX}_app composer update
    # - docker exec ${CONTAINER_PREFIX}_app composer install
    # - docker exec ${CONTAINER_PREFIX}_app php artisan migrate
    # - docker exec ${CONTAINER_PREFIX}_app php artisan cache:clear
    # - docker exec ${CONTAINER_PREFIX}_app php artisan config:cache
    # - docker exec ${CONTAINER_PREFIX}_app php artisan route:cache

prod_deploy:
  stage: deploy
  tags:
    - prod # выполнаяем на проде - на гитраннере с тегом prod
  only:
    - tags
  when: manual
  script:
    - export CONTAINER_PREFIX=sambia
    - docker compose -f docker-compose.prod.yml down --volumes --rmi all
    - docker compose -p $CONTAINER_PREFIX -f docker-compose.prod.yml up -d 
    - docker system prune -a -f # очистка всех НЕИСПОЛЬЗУЕМЫХ ресурсов на всякий случай, включая образы, сети, тома 

```

### Отладка скриптов в .gitlab-ci.yml
```yaml
test-job:
  script:
    - echo "Запуск тестов"
    - run-tests-command
  after_script:
    - echo "Задача завершилась с кодом $?"
```
Если тесты завершатся без ошибок, код будет 0, и вы увидите сообщение об успешном завершении. Если 1 или другое число, то значит что скрипт завершился ошибкой

# Весь процесс. Check list:
Когда мы коммитим в дев ветку, то 
1. запускается сборка докер образа с помощью гитлаб раннера с тегом build на локалке - это этап build
2. Логинимся в докер реджестри в гитлабе


















# Используемые команды и важные действия

## особенности
+ берем нужные переменные в https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
к примеру CI_COMMIT_SHA
+ проект на локалке должен быть в правах user:user
+ тестируем на локалке дев и прод сборку сначала для быстроты

## Используемые команды

### docker команды
билд и запуск одного образа и контейнера
+ docker build -t sambia-app -f _docker/app/gitlab/Dockerfile .  
+ docker run --name=smb -d --rm sambia-app 
+ docker exec -it smb bash
+ docker stop smb

+ docker compose -f docker-compose.dev.test.yml up -d  
+ docker exec -it sambia_app bash
+ docker compose -f docker-compose.dev.test.yml down --volumes --rmi all
+ docker run --name=smb -d --rm sambia-app 
+ 
+ docker compose build  перебилдить  образ снова в docker compose:
```yaml
  build: # при запуске docker compose собирается image на базе php:7.2-fpm, туда устанавливаются дополнения для php, копируется проект
      context: .
      dockerfile: _docker/app/Dockerfile
```

+ docker-compose down --volumes --rmi all         Остановка и удаление всех контейнеров, сетей, томов и образов, созданных в docker-compose
+ docker system prune -a      Очистка НЕИСПОЛЬЗУЕМЫХ peсурсов Docker
a: Удаляет все неиспользуемые образы, независимо от их состояния, а также остановленные контейнеры и неиспользуемые сети.


### git команды
+ git rm --cached /storage/framework/cache/* удаление из отслеживания гита после добавления в .dockerignore без удаления файлов из рабочего каталога
+ git branche develop создать новую ветку develop
+ git checkout develop
+ git remote -v     показать удаленные репозитории
+ git remote add origin
+ git commit -m "comments" обычный коммит
+ git commit -am "comments" добавить в стейдж и сразу закоммитить, но только отслеживаемые
+ git merge develop     находясь на ветке master слить ветку develop в master
+ 



# Gitlab переменные

Вот список самых популярных и часто используемых зарезервированных переменных в GitLab:

### 1. **CI/CD Pipeline и Job переменные**
- **`CI`**  
  Тип: `boolean`  
  Описание: Всегда имеет значение `true`, когда выполняется job в GitLab CI.

- **`CI_COMMIT_REF_NAME`**  
  Тип: `string`  
  Описание: Имя ветки или тега, для которого выполняется job (например, `main`, `feature-branch`, `v1.0.0`).

- **`CI_COMMIT_SHA`**  
  Тип: `string`  
  Описание: SHA-1 хэш текущего коммита.

- **`CI_COMMIT_SHORT_SHA`**  
  Тип: `string`  
  Описание: Короткий хэш текущего коммита (первая часть SHA-1, обычно первые 8 символов).

- **`CI_COMMIT_TITLE`**  
  Тип: `string`  
  Описание: Заголовок коммита, который был создан при выполнении пайплайна.

- **`CI_PIPELINE_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор пайплайна.

- **`CI_PIPELINE_URL`**  
  Тип: `string`  
  Описание: URL страницы с текущим пайплайном.

- **`CI_JOB_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор текущего job.

- **`CI_JOB_URL`**  
  Тип: `string`  
  Описание: URL страницы с текущим job.

- **`CI_JOB_NAME`**  
  Тип: `string`  
  Описание: Имя текущего job.

- **`CI_JOB_STAGE`**  
  Тип: `string`  
  Описание: Имя стадии пайплайна (например, `build`, `test`, `deploy`).

- **`CI_NODE_INDEX`**  
  Тип: `integer`  
  Описание: Индекс параллельной job, начиная с 0.

- **`CI_NODE_TOTAL`**  
  Тип: `integer`  
  Описание: Общее количество параллельных job в данной группе.

### 2. **Переменные проекта**
- **`CI_PROJECT_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор проекта в GitLab.

- **`CI_PROJECT_NAME`**  
  Тип: `string`  
  Описание: Имя проекта.

- **`CI_PROJECT_PATH`**  
  Тип: `string`  
  Описание: Полный путь до проекта, включая группы (например, `group/project-name`).

- **`CI_PROJECT_URL`**  
  Тип: `string`  
  Описание: URL репозитория проекта.

- **`CI_PROJECT_NAMESPACE`**  
  Тип: `string`  
  Описание: Пространство имен проекта, которое включает группу (например, `my-group`).

### 3. **Переменные окружения и runner'ов**
- **`CI_SERVER_URL`**  
  Тип: `string`  
  Описание: URL GitLab сервера.

- **`CI_SERVER_NAME`**  
  Тип: `string`  
  Описание: Имя сервера GitLab (обычно `GitLab`).

- **`CI_SERVER_VERSION`**  
  Тип: `string`  
  Описание: Версия GitLab сервера.

- **`CI_RUNNER_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор runner'а, на котором выполняется job.

- **`CI_RUNNER_DESCRIPTION`**  
  Тип: `string`  
  Описание: Описание runner'а, на котором выполняется job.

- **`CI_RUNNER_TAGS`**  
  Тип: `string`  
  Описание: Теги runner'а, которые можно использовать для фильтрации и выбора runner'ов в pipeline.

### 4. **Переменные пользователя**
- **`GITLAB_USER_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор пользователя, запустившего pipeline.

- **`GITLAB_USER_LOGIN`**  
  Тип: `string`  
  Описание: Логин пользователя, запустившего pipeline.

- **`GITLAB_USER_EMAIL`**  
  Тип: `string`  
  Описание: Email пользователя, запустившего pipeline.

### 5. **Переменные окружения для Docker и Kubernetes**
- **`CI_REGISTRY`**  
  Тип: `string`  
  Описание: URL контейнерного реестра GitLab (например, `registry.gitlab.com`).

- **`CI_REGISTRY_IMAGE`**  
  Тип: `string`  
  Описание: URL образа в реестре контейнеров для текущего проекта.

- **`CI_KUBERNETES_NAMESPACE`**  
  Тип: `string`  
  Описание: Пространство имен Kubernetes, в котором разворачиваются ресурсы.

### 6. **Переменные для деплоя**
- **`CI_ENVIRONMENT_NAME`**  
  Тип: `string`  
  Описание: Имя окружения, в котором выполняется деплой (например, `production`, `staging`).

- **`CI_ENVIRONMENT_URL`**  
  Тип: `string`  
  Описание: URL для доступа к окружению.

- **`CI_DEPLOY_USER`**  
  Тип: `string`  
  Описание: Имя пользователя, который выполняет деплой.

- **`CI_DEPLOY_PASSWORD`**  
  Тип: `string`  
  Описание: Пароль для деплоя.

### 7. **Переменные сборки и артефактов**
- **`CI_COMMIT_REF_PROTECTED`**  
  Тип: `boolean`  
  Описание: Значение `true`, если текущая ветка защищена.

- **`CI_JOB_TOKEN`**  
  Тип: `string`  
  Описание: Токен для аутентификации в других сервисах внутри job'а.

- **`CI_JOB_ARTIFACTS_PATH`**  
  Тип: `string`  
  Описание: Путь к артефактам, которые сохраняются после выполнения job'а.

Эти переменные значительно упрощают настройку CI/CD пайплайнов в GitLab, позволяя автоматизировать множество процессов и гибко настраивать деплой и сборку приложения.


















создаем базовый docker-compose.yml
```yml
version: '3'
services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ # прокидываем сайт
      - ./nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - "8080:80"
    container_name: app_nginx
```
В папке корневой создаем index.html

## добавляем модуль php-fpm
чтобы nginx мог проксировать php запросы в сервис php

Добавляем сервис php в docker-compose.yml
```yaml
  php:
    image: php:7.2-fpm
    volumes:
      - ./:/var/www
```

Добавляем в конфиг nginx:  
```nginx
 location ~ \.php$ {  # Обрабатываем все запросы к PHP-файлам
        try_files $uri =404;  # Проверяем наличие файла, если файл не найден - возвращаем 404 ошибку
        fastcgi_split_path_info ^(.+\.php)(/.+)$;  # Разбиваем URL на два компонента: путь к PHP-файлу и дополнительную информацию (PATH_INFO)
        fastcgi_pass php:9000;  # Передаем запрос PHP-FPM, работающему на сокете php:9000
        fastcgi_index index.php;  # Устанавливаем index.php как индексный файл для директорий
        include fastcgi_params;  # Включаем стандартные параметры FastCGI для передачи на PHP-FPM
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # Указываем полный путь к PHP-файлу на сервере
        fastcgi_param PATH_INFO $fastcgi_path_info;  # Передаем переменную PATH_INFO, которая содержит дополнительную информацию после имени PHP-файла
    }
```

## Установка composer

curl -sS https://getcomposer.org/installer | php  
sudo mv composer.phar /usr/local/bin/composer  

создаем проект  
composer create-project laravel/laravel lara_docker  

в проект добавляем docker-compose.yml и папку _docker со всем необходимым dockerfile, nginx.conf, php.ini  



# nginx.conf теперь имеет вид

не забываем что в строке  fastcgi_pass app:9000; указываем имя сервиса app к которому обращаемся
```conf
server {
    root /var/www/public/;

    location / {
        try_files $uri /index.php;
        # kill cache
        add_header Last-Modified $date_gmt;
        add_header Cache-Control 'no-store, no-cache';
        if_modified_since off;
        expires off;
        etag off;
    }
  
    location ~ \.php$ {  # Обрабатываем все запросы к PHP-файлам
        try_files $uri =404;  # Проверяем наличие файла, если файл не найден - возвращаем 404 ошибку
        fastcgi_split_path_info ^(.+\.php)(/.+)$;  # Разбиваем URL на два компонента: путь к PHP-файлу и дополнительную информацию (PATH_INFO)
    # ВНИМАНИЕ тут указываем как и имя сервиса app в docker-compose
        fastcgi_pass app:9000;  # Передаем запрос PHP-FPM, работающему на сокете php:9000
        fastcgi_index index.php;  # Устанавливаем index.php как индексный файл для директорий
        include fastcgi_params;  # Включаем стандартные параметры FastCGI для передачи на PHP-FPM
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # Указываем полный путь к PHP-файлу на сервере
        fastcgi_param PATH_INFO $fastcgi_path_info;  # Передаем переменную PATH_INFO, которая содержит дополнительную информацию после имени PHP-файла
    }
}
```


# docker-compose теперь имеет вид
```yml
services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ # прокидываем сайт
      - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - "8080:80"
    container_name: app_nginx
    depends_on:
      - app
 
  app:
    # image: php:7.2-fpm
    build:
      context: .
      dockerfile: _docker/app/Dockerfile
    volumes:
      - ./:/var/www
    container_name: app
```

# добавляем mysql

Итого docker-compose.yml принимает вид
```yml
# version: '3'

services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ # прокидываем сайт
      - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - 8080:80
    container_name: app_nginx
    depends_on:
      - app
 
  app:
    # image: php:7.2-fpm
    build:
      context: .
      dockerfile: _docker/app/Dockerfile
    volumes:
      - ./:/var/www
    depends_on:
      - db
    container_name: app
    
  db:
    image: mysql:5.7
    restart: always # если контейнер упал, то докер его перезапускает
    volumes:
      - ./tmp/db:/var/lib/mysql # стандартный путь для mysql /var/lib/mysql
    environment:
      MYSQL_DATABASE: sambiaho_sambia
      MYSQL_ROOT_PASSWORD: adm456456
      #MYSQL_USER: sambiaho_last
      #MYSQL_PASSWORD: adm456456
    ports:
      - 3333:3306
    command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    container_name: db
```
указываем инфу для подключения к БД в .env
```conf
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=sambiaho_sambia
DB_USERNAME=root
DB_PASSWORD=adm456456
```


# October

docker compose yaml принял вид
```yml
# version: '3'

services:
  nginx:
    image: nginx
    volumes:
      - ./:/var/www/ # прокидываем сайт
      - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/ # прокидываем конфиг nginx
    ports:
      - 80:80
    container_name: app_nginx
    depends_on:
      - app
    networks:
      - app_network            # Сеть для взаимодействия с PHP
 
  app:
    # image: php:7.2-fpm
    build:
      context: .
      dockerfile: _docker/app/Dockerfile
    working_dir: /var/www/
    environment:
      - MYSQL_HOST=db          # Имя сервиса базы данных
      - MYSQL_PORT=3306        # Порт для MySQL
      - MYSQL_DATABASE=sambiaho_sambia # Имя базы данных
      - MYSQL_USER=sambiaho_last    # Пользователь базы данных
      - MYSQL_PASSWORD=adm456456 # Пароль пользователя базы данных
    volumes:
      - ./:/var/www
    depends_on:
      - db
    container_name: app
    networks:
      - app_network            # Сеть для взаимодействия с PHP
    
  db:
    image: mysql:5.7
    restart: always # если контейнер упал, то докер его перезапускает
    volumes:
      - db_data:/var/lib/mysql     # Том для хранения данных базы данных
      - ./db/backup.sql:/docker-entrypoint-initdb.d/backup.sql # Восстанавливаем базу данных из дампа при первом запуске
    #  - ./tmp/db:/var/lib/mysql # стандартный путь для mysql /var/lib/mysql
    environment:
      - MYSQL_HOST=db          # Имя сервиса базы данных
      - MYSQL_PORT=3306        # Порт для MySQL
      - MYSQL_DATABASE=sambiaho_sambia # Имя базы данных
      - MYSQL_USER=sambiaho_last    # Пользователь базы данных
      - MYSQL_PASSWORD=adm456456 # Пароль пользователя базы данных
      - MYSQL_ROOT_PASSWORD=root
    ports:
      - 3333:3306
    #command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    container_name: db
    networks:
      - app_network            # Сеть для взаимодействия с PHP

volumes:
  db_data:  # Том для хранения данных MySQL

networks:
  app_network:  # Сеть для взаимодействия сервисов
  
```
+ создали docker-compose-prod.yaml с разницей в порте 80:80
+ закинули на прод с гитхаба самбию
+ скопировали папку storage
+ дали права на storage 777, можно и 755
+ в папку db скопировали backup.sql
+ запустили docker compose -f docker-compose-prod.yam up -d
+ все заработало
+ залили на гитлаб
+ устанавливаем гитлабраннеры на прод и дев через бинарник  и все СТРОГО ЧЕРЕЗ SUDO:
https://docs.gitlab.com/runner/install/linux-manually.html  



+ Устанавливаем git на удаленном серваке чтожбы раннеры могли выполнятся
+ в гитлабе создаем новую ветку develop и подтягиваем ее в локальный репозиторий
+ Создаем gitlab-ci.yml и пушим. Смотрим выполение тестпайплайна
```yaml
stages:
  - first
  - second
  - third

print_test:
  stage: first
  tags:
    - build
  only:
    - develop
  script:
    - echo "another:$CI_COMMIT_SHA/$CI_COMMIT_TITLE"

print_second:
  stage: second
  tags:
    - build
  only:
    - develop
  script:
    - echo "app:$CI_REGISTRY_USER/$CI_REGISTRY/$CI_RUNNER_TAGS"
print_third:
  stage: third
  tags:
    - build
  only:
    - develop
  script:
    - echo "Hello Alex from third 3333333333"
```
+ Создаем переменнные в гитлабе. Protect variable - Когда эта опция включена, переменная будет доступна только для пайплайнов, которые запускаются на защищённых ветках (например, main, production) или для защищённых тегов.
Это полезно для сохранения безопасности важных данных (таких как ключи доступа или пароли), чтобы они не утекли через неопределённые ветки или тестовые среды.  
Expand variable reference (Развернуть ссылку на переменную): При включении этой опции значение переменной может содержать ссылки на другие переменные с использованием синтаксиса $.
Например, если у вас есть две переменные:
API_URL = https://api.example.com
FULL_API_URL = ${API_URL}/v1
Если опция включена, переменная FULL_API_URL развернётся как https://api.example.com/v1, используя значение переменной API_URL.
Без этой опции, переменная FULL_API_URL будет интерпретироваться буквально как ${API_URL}/v1.

Для проекта на October CMS
### 1. **Переменные базы данных**:
   - **DB_HOST**: Адрес сервера базы данных (например, `localhost` или IP-адрес внешнего сервера).
   - **DB_DATABASE**: Имя базы данных для проекта October CMS.
   - **DB_USERNAME**: Имя пользователя базы данных.
   - **DB_PASSWORD**: Пароль для пользователя базы данных.
   - **DB_PORT**: Порт для подключения к базе данных (по умолчанию MySQL использует порт `3306`).

Пример:
```bash
DB_HOST = localhost
DB_DATABASE = october_cms
DB_USERNAME = your_db_user
DB_PASSWORD = your_db_password
DB_PORT = 3306
```

### 2. **Переменные для окружения Laravel/October CMS**:
   - **APP_ENV**: Указывает окружение проекта (`production`, `local`, `staging`).
   - **APP_KEY**: Ключ шифрования для приложения, который можно сгенерировать командой `php artisan key:generate`.
   - **APP_DEBUG**: Включение или отключение отладки (`true` для разработки, `false` для продакшн).
   - **APP_URL**: URL вашего приложения, например, `https://example.com`.

Пример:
```bash
APP_ENV = production
APP_KEY = base64:qwertyuiop1234567890==  # Сгенерированный ключ
APP_DEBUG = false
APP_URL = https://example.com
```

### 3. **Переменные для управления GitLab CI/CD**:
   - **CI_COMPOSER_INSTALL_FLAGS**: Флаги для установки зависимостей через Composer. Например, `--no-dev` для продакшн или `--prefer-dist` для кэширования зависимостей.
   
Пример:
```bash
CI_COMPOSER_INSTALL_FLAGS = --no-dev --prefer-dist
```

### 4. **Переменные для кэширования** (по желанию):
   - **CACHE_DRIVER**: Драйвер кэширования, например, `file` или `redis`, если используется Redis.
   - **SESSION_DRIVER**: Драйвер сессий, например, `file` или `database`.

Пример:
```bash
CACHE_DRIVER = file
SESSION_DRIVER = file
```

### 5. **Дополнительные переменные для развертывания**:
   - **DEPLOY_USER** и **DEPLOY_PASSWORD**: Учётные данные для доступа к серверу при деплое (если используется автоматическое развертывание).
   - **DEPLOY_HOST**: Адрес сервера для деплоя.

Эти переменные нужно добавить в **Settings > CI / CD > Variables** в вашем проекте GitLab, чтобы они были доступны во время выполнения пайплайна.

gitlabci принимает вид
```yaml
stages:
  - first

print_test:
  stage: first
  tags:
    - build
  only:
    - develop
  script:
    - export NEW="blalblalba" # создаем новую переменную прямо отсюда
    - echo $NEW
    - echo $APP_DEBUG
    - echo $APP_ENV
    - echo $APP_URL
    - echo $DB_CONNECTION
    - echo $DB_DATABASE
    - echo $DB_HOST
    - echo $DB_PASSWORD
    - echo $DB_PORT
    - echo $DB_ROOT_PASSWORD
    - echo $DB_USERNAME

```
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 



можем так же удалить все ресурсы докера включая все образы (флаг -a)
docker system prune -a
+ a: Удаляет все неиспользуемые образы, независимо от их состояния, а также остановленные контейнеры и неиспользуемые сети.

чтобы сервис php_app не вырубался при скрипте, то надо добавить к команде && php-fpm

+ 
+ 

б

# доп инфо

sudo systemctl restart nginx

Для указания пути к сайту в Nginx правильнее всего настраивать конфигурацию в директории /etc/nginx/sites-available/, например, в файле /etc/nginx/sites-available/default. Этот подход считается хорошей практикой, так как конфигурация для каждого сайта хранится отдельно, что упрощает управление множеством сайтов.

Использование /etc/nginx/sites-available/ и создания симлинков в /etc/nginx/sites-enabled/ — стандартный подход в большинстве дистрибутивов. Файл /etc/nginx/nginx.conf или файлы в директории /etc/nginx/conf.d/ обычно используются для общесистемных настроек или специфичных конфигураций, например, для проксирования или кэша.




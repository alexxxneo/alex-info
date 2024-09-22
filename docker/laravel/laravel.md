

# создаем nginx базу 
Создаем базовый конфиг nginx.conf в nginx/conf.d/
server {
    root /var/www/public;

    location / {
        try_files $uri /index.html;
    }

    # тестовая страница по другому пути
    # location /asd {
    #     try_files $uri /asd.html;
    # }
}

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

# добавляем модуль php-fpm
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

# Установка composer

curl -sS https://getcomposer.org/installer | php  
sudo mv composer.phar /usr/local/bin/composer  

создаем проект  
composer create-project laravel/laravel lara_docker  

в проект добавляем docker-compose.yml и папку _docker со всем необходимым dockerfile, nginx.conf, php.ini  

Создаем Dockerfile
```Dockerfile
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
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#копируем php.ini
COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini


#Install composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- \
    --filename=composer \
    --install-dir=/usr/local/bin

WORKDIR /var/www
 RUN chmod -R 777 storage && chmod -R 777 bootstrap/cache
```

копируем php.ini
```conf
cgi.fix_pathinfo=0
max_execution_time = 1000
max_input_time = 1000
memory_limit=4G
```

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
+ устанавливаем гитраннеры на прод и дев https://docs.gitlab.com/runner/install/  
https://docs.gitlab.com/runner/install/linux-repository.html
  ```bash
  curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
  
  sudo apt-get install gitlab-runner


```
если не работает то через бинарник:
https://docs.gitlab.com/runner/install/linux-manually.html  
```bash
sudo curl -L --output /usr/local/bin/gitlab-runner "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64"

sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

sudo rm -rf /etc/systemd/system/gitlab-runner.service
sudo gitlab-runner install --user=root

sudo gitlab-runner start

# только сначала создаем раннер для проекта в разделе настройки cicd runners
sudo gitlab-runner register  --url https://gitlab.com  --token glrt-vMwGxPkvCYb8sR1HkDLZ

 sudo gitlab-runner restart

```
Создаем gitlab-ci.yml
Пушим в гитлаб
в гитлабе создаем новую ветку develop и подтягиваем ее в локальный репозиторий
берем нужные переменные в https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
к примеру CI_COMMIT_SHA

# доп инфо

sudo systemctl restart nginx

Для указания пути к сайту в Nginx правильнее всего настраивать конфигурацию в директории /etc/nginx/sites-available/, например, в файле /etc/nginx/sites-available/default. Этот подход считается хорошей практикой, так как конфигурация для каждого сайта хранится отдельно, что упрощает управление множеством сайтов.

Использование /etc/nginx/sites-available/ и создания симлинков в /etc/nginx/sites-enabled/ — стандартный подход в большинстве дистрибутивов. Файл /etc/nginx/nginx.conf или файлы в директории /etc/nginx/conf.d/ обычно используются для общесистемных настроек или специфичных конфигураций, например, для проксирования или кэша.




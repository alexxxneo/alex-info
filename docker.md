# Создание стенда для теста ansible
Создадим сначала докер образ из базового ubuntu. Создадим в образе пользователя user. Загрузим публичный ключ в образ и выдадим ему нужные права. Создадим сеть с типом bridge.В ней запустим нужное количество контейнеров и подключимся с хоста по ssh


## Создаем сеть
Создаем сеть типа bridge для того чтобы можно было запустить несколько контейнеров с открытым портом 22. По умолчанию в обычной сети стоит ограничение на один открытый внешний конкретный порт - его может использовать только  1 контейнер
```bash
docker network create --driver bridge my_bridge_network

#проверяем, смотрим список сетей
docker network ls
```


## 1. Создание Dockerfile

Создайте Dockerfile, который будет базироваться на образе Ubuntu, устанавливать SSH-сервер и настраивать доступ через SSH:

```Dockerfile
# Используем официальный образ Ubuntu в качестве основы
FROM ubuntu:latest

# Устанавливаем OpenSSH Server и sudo
RUN apt-get update && apt-get install -y openssh-server sudo

# Создаем директорию для работы SSH
RUN mkdir /var/run/sshd

# Добавляем пользователя с именем 'user' и назначаем пароль 'password'
RUN useradd -rm -d /home/user -s /bin/bash -G sudo -u 1001 user
RUN echo 'user:mypass123' | chpasswd

# Настраиваем SSH для входа под пользователем root
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config
RUN echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config
RUN echo 'UsePAM yes' >> /etc/ssh/sshd_config

# Копируем публичный ключ с хоста
COPY authorized_keys /home/user/.ssh/authorized_keys
RUN chown -R user /home/user/.ssh && chmod 600 /home/user/.ssh/authorized_keys

# Открываем порт 22 для SSH
EXPOSE 22

# Запускаем SSH-сервер
CMD ["/usr/sbin/sshd", "-D"]

```

## Копирование публичного ключа

Скопируйте ваш публичный ключ в файл `authorized_keys` в той же директории, где находится `Dockerfile`.

```bash
cp ~/.ssh/id_rsa.pub authorized_keys
```

## Сборка Docker образа

Соберите Docker образ, используя созданный `Dockerfile`:

## Запускаем контейнер
```bash
docker run -d --rm --name client1 -p 22:22 --network ansible_network  ansible_client
```

## Узнаем ip адрес контейнера
```bash
docker network inspect ansible_network
```

##  Подключаемся
```bash
ssh user@172.18.0.2
```


## Добавляем docker compose
Для облегчения управления используем docker compose

внешние порты мы можем ставить любые, т.к. подключаемся изнутри. Т.е. сеть bridge подразумеваем единую сеть хоста и контейнеров
```yaml
services:
  container1:
    image: ansible_client
    container_name: container1
    networks:
      - ans_net
    ports:
      - "22:22"  

  container2:
    image: ansible_client 
    container_name: container2
    networks:
      - ans_net
    ports:
      - "23:22"  

  container3:
    image: ansible_client  
    container_name: container3
    networks:
      - ans_net
    ports:
      - "24:22"  

networks:
  ans_net:
    driver: bridge

```
список команд для удобств которые использовались

```bash
# запуск контейнеров в фоновом режиме
docker compose up -d

# список запущенных контейнеров
docker ps

# остановка и удаление всех ресурсов
docker compose down

# можем так же удалить все ресурсы докера
docker system prune
# либо частично
docker network prune
docker container prune

# список созданных сетей
docker network ls

# просмотр сведений о сети и запущенных в ней контейнеров. Ищем ip адреса контейнеров
docker network inspect docker_ans_net

```



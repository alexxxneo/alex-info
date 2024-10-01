

# DOCKER

помимо команд из инструкции чтобы не было ошибки с правами или не запускать постоянно от sudo еще нужно
sudo groupadd docker
sudo usermod -aG docker $USER
перезагружаем систему

Команды работы с образами:
docker build: Создает образ Docker из Dockerfile.
docker pull: Загружает образ из реестра контейнеров.
docker push: Публикует образ в реестр контейнеров.
docker images: Показывает список доступных образов на вашем компьютере.
docker rmi: Удаляет один или несколько образов.
docker history: Показывает историю команд сборки образа.
docker tag: Добавляет тег к существующему образу Docker.
docker save: Сохраняет образ в архивный файл.
docker load: Загружает образ из архивного файла.
docker inspect: Показывает подробную информацию об образе.
docker search: Ищет образы в реестре контейнеров Docker Hub.
docker prune: Удаляет неиспользуемые образы.


Команды работы с контейнерами:
docker run: Создает и запускает контейнер из указанного образа.
docker start: Запускает остановленный контейнер.
docker stop: Останавливает работающий контейнер.
docker stop $(docker ps -q) останавливает абсолютно все контейнеры
docker rm -f $(docker ps -aq) удаляет абсолютно все контейнеры


docker restart: Перезапускает контейнер.
docker rm: Удаляет один или несколько контейнеров.
docker ps: Показывает список активных контейнеров.
docker logs: Показывает логи контейнера.
docker exec: Запускает новый процесс внутри контейнера. 
	например подключиться к shell контейнера alpine docker exec -it alex_react_nginx_container /bin/sh
docker inspect: Показывает подробную информацию о контейнере.
docker kill: Принудительно завершает работу контейнера.
docker pause: Приостанавливает все процессы в контейнере.
docker unpause: Возобновляет выполнение всех процессов в контейнере.
Другие команды Docker:

docker-compose: Управляет многоконтейнерными приложениями с помощью файла docker-compose.yml.
docker version: Показывает информацию о версии Docker.
docker info: Показывает общую информацию о системе Docker.
docker network: Управляет сетями Docker.
docker volume: Управляет томами Docker.
docker system: Управляет Docker системными ресурсами.
docker login: Входит в систему в реестре контейнеров Docker Hub.

docker build  Флаги команды позволяют управлять процессом сборки образа Docker и настраивать его поведение. Вот список всех доступных флагов с их описанием:
-f, --file: Указывает Dockerfile для использования. По умолчанию Docker ищет файл с именем Dockerfile в текущем каталоге.
--build-arg=[]: Передает аргументы сборки в Dockerfile.
--cache-from=[]: Использует указанные образы в качестве кэша сборки.
--cgroup-parent="string": Устанавливает родительский cgroup для контейнера.
--cpu-period=0: Устанавливает период CPU ограничения в микросекундах.
--cpu-quota=0: Устанавливает квоту CPU в микросекундах.
--cpu-shares=0: Устанавливает вес CPU (CPU shares) (относительно других контейнеров).
--cpuset-cpus="string": Устанавливает список ядер CPU (номеров или диапазонов, разделенных запятыми) в виде строки.
--cpuset-mems="string": Устанавливает список узлов памяти (номеров или диапазонов, разделенных запятыми) в виде строки.
--disable-content-trust: Отключает проверку доверия контента.
--iidfile "string": Записывает идентификатор образа в файл.
--isolation="string": Устанавливает режим изоляции контейнера.
--label=[]: Устанавливает метку для контейнера.
--label-file=[]: Читает метки из файла в формате JSON или YAML.
--memory="string": Устанавливает ограничение памяти для контейнера.
--memory-swap="string": Устанавливает общее количество памяти и обмена для контейнера.
--network="string": Устанавливает сеть для сборки образа.
--no-cache: Игнорирует существующий кэш сборки.
--platform="string": Устанавливает платформу для сборки образа.
--progress="string": Устанавливает уровень прогресса вывода (auto, plain, tty).
--pull: Запрашивает обновления базовых образов перед сборкой.
--quiet, -q: Уменьшает вывод до минимума, показывая только идентификаторы слоев.
--rm													 Удаляет все вспомогательные контейнеры после завершения сборки.
--security-opt=[]: Устанавливает параметры безопасности для сборки образа.
--shm-size="string": Устанавливает размер разделяемой памяти для сборки образа.
--squash: Сжимает слои образа в единственный слой.
--ssh "string": Устанавливает ключ SSH для сборки.
--stream: Выводит собранные слои как они появляются.
-t 														--tag  Устанавливает тег для собираемого образа.
--target "string": Устанавливает цель сборки Dockerfile по имени.
--ulimit=[]: Устанавливает уровни ограничения для ресурсов внутри контейнера.
--volume=[]: Монтирует точку монтирования (volume) в контейнер.

## Docker
docker images — смотрим images в наличии и узнаём ID нашего
docker images -a — смотрим images, в том числе не активные
docker ps — смотрим запущенные контейнеры
docker ps -a — смотрим список всех контейнеров, включая неактивные
docker login username darkbenladan --password password — логинимся по логину и паролю, которые мы создали на hub.docker.com ранее
docker save 3c156928aeec > start.tar — сохраняем локально наш контейнер, теперь мы можем его перенести куда угодно
docker rm -f $(docker ps -a -q) — удалим и принудительно остановим все контейнеры
docker load < start.tar — мы вернули наш контейнер

Информация и регистрация
docker info - Информация обо всём в установленном Docker
docker history - История образа
docker tag - Дать тег образу локально или в registry
docker login - Залогиниться в registry
docker search - Поиск образа в registry
docker pull - Загрузить образ из Registry себе на хост
docker push - Отправить локальный образ в registry

Управление контейнерами 
docker ps -а - Посмотреть все контейнеры
docker start container-name - Запустить контейнер
docker kill/stop container-name - Убить (SIGKILL) /Остановить (SIGTERM) контейнер
docker logs --tail 100 container-name - Вывести логи контейнера, последние 100 строк
docker inspect container-name - Вся инфа о контейнере + IP
docker rm container-name- Удалить контейнер (поле каждой сборки Dockerfile)
docker rm -f $(docker ps -aq) - Удалить все запущенные и остановленные контейнеры
docker events container-name - Получения событий с контейнера в реальном времени.
docker port container-name - Показать публичный порт контейнера
docker top container-name - Отобразить процессы в контейнере
docker stats container-name - Статистика использования ресурсов в контейнере
docker diff container-name - Изменения в ФС контейнера
docker container commit -m "added alex.txt" alexcontainer aleximage:alextag	 сохранение контейнера в образ
docker run -it aleximage:alextag запуск нашего созданного образа. Все данные из прошлого созданного контейнера сохранены в этом образе

Запуск docker (Run)
docker run -d -p 80:80 -p 22:22 debian:11.1-slim sleep infinity (--rm удалит после закрытия контейнера, --restart unless-stopped добавит автозапуск контейнера) - Запуск контейнера интерактивно или как демона/detached (-d), Порты: слева хостовая система, справа в контейнере, пробрасывается сразу 2 порта 80 и 22, используется легкий образ Debian 11 и команда бесконечный сон
docker update --restart unless-stopped redis - добавит к контейнеру правило перезапускаться при закрытии, за исключением команды стоп, автозапуск по-сути
docker exec -it container-name /bin/bash (sh для alpine) - Интерактивно подключиться к контейнеру для управления, exit чтобы выйти
docker attach container-name - Подключиться к контейнеру чтоб мониторить ошибки логи в реалтайме

ФЛАГИ docker run :
--add-host=[]: Добавляет записи в файл /etc/hosts контейнера.
--attach, -a: Прикрепляет STDOUT/STDERR и/или создает взаимодействие с STDIN. 	docker run -a stdin -a stdout -a stderr nginx
--cgroup-parent="string": Устанавливает родительский cgroup для контейнера.
--cidfile="string": Записывает идентификатор контейнера в файл.
-d		--detach, Запускает контейнер в фоновом режиме.			docker run -d nginx
--detach-keys="string": Назначает клавиши, используемые для отсоединения от контейнера в фоновом режиме.
--device=[]: Добавляет устройство хоста к контейнеру.
--dns=[]: Устанавливает адреса DNS-серверов для контейнера.
--dns-option=[]: Устанавливает опции DNS-запроса.
--dns-search=[]: Устанавливает поисковые домены DNS.
--domainname="string": Устанавливает доменное имя контейнера.
--entrypoint="string": Переопределяет точку входа по умолчанию.
-e											 --env, -e=[]: Устанавливает переменные среды.		
											docker run -e MYSQL_ROOT_PASSWORD=pass123 mysql
--env-file=[]: Читает переменные среды из файла в формате <key>=<value>.
--expose=[]: Публикует порты контейнера к хосту.
--group-add=[]: Добавляет дополнительные группы к пользователю в контейнере.
--health-cmd="string": Команда, используемая для проверки состояния здоровья контейнера.
--health-interval=0: Интервал времени между проверками состояния здоровья.
--health-retries=0: Количество проверок состояния здоровья перед объявлением контейнера нездоровым.
--health-start-period=0: Время запуска контейнера для начала проверок состояния здоровья.
--health-timeout=0: Время ожидания проверки состояния здоровья.
--hostname="string": Устанавливает имя хоста контейнера.
--init: Использует init процесс в контейнере для управления его жизненным циклом.
-i 														--interactive, -i: Взаимодействует с STDIN контейнера.  		
														docker run -i ubuntu /bin/bash запускает контейнер с образом Ubuntu и выполняет команду /bin/bash, что открывает интерактивный сеанс Bash внутри контейнера.
														docker run -it alpine /bin/sh														
														-i, --interactive: Поддерживает стандартный ввод (stdin) открытым.
														-t, --tty: Подключает псевдо-терминал (tty).
--ip="string": Устанавливает IP-адрес контейнера.
--ip6="string": Устанавливает IPv6-адрес контейнера.
--ipc="string": Устанавливает namespace IPC для контейнера.
--isolation="string": Устанавливает режим изоляции контейнера.
--kernel-memory="string": Устанавливает ограничение памяти ядра для контейнера.
--label=[]: Устанавливает метку для контейнера.
--label-file=[]: Читает метки из файла в формате JSON или YAML.
--link=[]: Связывает контейнер с другим контейнером.
--log-driver="string": Устанавливает драйвер журнала для контейнера.
--log-opt=[]: Устанавливает параметры журнала для контейнера.
--mac-address="string": Устанавливает MAC-адрес контейнера.
--memory="string": Устанавливает ограничение памяти для контейнера.
--memory-reservation="string": Устанавливает резервирование памяти для контейнера.
--memory-swap="string": Устанавливает общее количество памяти и обмена для контейнера.
--memory-swappiness=-1: Устанавливает swappiness для контейнера.
--mount											 		Монтирует точку монтирования (volume) в контейнер.
--name													Устанавливает имя контейнера.
--network="string": Устанавливает сеть для контейнера.
--network-alias=[]: Добавляет алиасы сети для контейнера.
--no-healthcheck: Отключает проверку состояния здоровья.
--oom-kill-disable: Отключает убийство процессов из-за нехватки памяти.
--oom-score-adj=-500: Устанавливает смещение приоритета OOM.
--pid="string": Устанавливает namespace PID для контейнера.
--pids-limit=0: Устанавливает ограничение PID для контейнера.
--platform="string": Устанавливает платформу для контейнера.
--privileged: Дает контейнеру доступ ко всему хостовому устройству.
-p 									--publish, Публикует порты контейнера к хосту.		docker run -d -p 8080:80 nginx
--publish-all, -P: Публикует все порты контейнера к хосту.
--read-only: Устанавливает файловую систему контейнера в режим только для чтения.
--restart="string": Перезапускает контейнер после его завершения.
--rm													 Удаляет контейнер после его завершения.
--runtime="string": Устанавливает среду выполнения (runtime) для контейнера.
--security-opt=[]: Устанавливает параметры безопасности для контейнера.
--shm-size="string": Устанавливает размер разделяемой памяти для контейнера.
--sig-proxy=true: Перехватывает сигналы перед отправкой их в контейнер.
--stop-signal="string": Устанавливает сигнал остановки контейнера.
--stop-timeout=10: Устанавливает тайм-аут остановки контейнера в секундах.
--storage-opt=[]: Устанавливает параметры хранения для контейнера.
--sysctl=[]: Устанавливает sysctl параметры для контейнера.
--tmpfs=[]: Монтирует tmpfs в контейнер.
--tty, -t: Выделяет псевдотерминал для контейнера.
--ulimit=[]: Устанавливает уровни ограничения для ресурсов внутри контейнера.
--user="string": Устанавливает пользователя или UID для контейнера.
--userns="string": Устанавливает namespace пользователя для контейнера.
--uts="string": Устанавливает namespace UTS для контейнера.
--volume-driver="string": Устанавливает драйвер тома для контейнера.
-v 		--volumes-from=[]: Монтирует тома из указанных контейнеров.
--workdir, -w="string": Устанавливает рабочий каталог (working directory) в контейнере.

## Хранилище (Volumes)

Создание тома 					docker volume create my_volume
Выяснить информацию о томах 	docker volume ls
Исследовать конкретный том  	docker volume inspect my_volume
Удаление тома 					docker volume rm my_volume
Удалить все тома 				docker volume prune

Очистка peсурсов Docker 		docker system prune
docker system prune -a
a: Удаляет все неиспользуемые образы, независимо от их состояния, а также остановленные контейнеры и неиспользуемые сети.

Использовать надо флаг --mount, а не --volume, который устарел
docker container run --mount source=my_volume, target=/container/path/for/volume my_image		 запускаем докер и примаунчиваем созданный ранее том
Параметры --mount
		● type — тип монтирования. Значением для соответствующего ключа могут выступать bind,
		volume или tmpfs. Мы тут говорим о томах, то есть нас интересует значение volume
		● source — источник монтирования. Для именованных томов — это имя тома.
		Для неименованных томов этот ключ не указывают. Он может быть сокращён до src
		● destination — путь, к которому файл или папка монтируется в контейнере.
		Этот ключ может быть сокращён до dst или target
		● readonly — монтирует том, который предназначен только для чтения. Использовать этот ключ необязательно, значение ему не назначают
Пример использования --mount с множеством параметров:
docker run --mount type=volume,source=volume_name,destination=/path/in/container,readonly
my_image

МОНТИРОВАНИЕ Примеры команд
Монтирование тома:
	docker volume create my-volume
	docker run -d --name my-container -v my-volume:/data my-image
Монтирование привязки:
	docker run -d --name my-container -v /host/path:/container/path my-image
Монтирование tmpfs:
	docker run -d --name my-container --tmpfs /tmp my-image

Скопировать в корень контейнера file
docker cp file <containerID>:/

Скопировать file из корня контейнера в текущую директорию командной строки
docker cp <containerID>:/file .


Чтобы получить доступ к данным в volume `db_data` и посмотреть файлы, вы можете использовать несколько методов. Один из наиболее простых способов — временно запустить контейнер, который имеет доступ к этому volume, и затем просмотреть его содержимое. Вот как это сделать:

### 1. Использование временного контейнера

Запустите временный контейнер с доступом к тому же volume:

```bash
docker run --rm -it -v db_data:/data alpine sh
```

Здесь:
- `--rm` удаляет контейнер после выхода.
- `-it` запускает контейнер в интерактивном режиме.
- `-v db_data:/data` монтирует volume `db_data` в директорию `/data` внутри контейнера.
- `alpine` — это легкий образ Linux, который можно использовать для доступа к файловой системе.
- `sh` запускает оболочку `sh` внутри контейнера.

После запуска этой команды, вы окажетесь в командной строке контейнера. Вы можете просматривать файлы с помощью команд, таких как `ls`, `cd`, `cat`, и т.д.

Пример команд:

```sh
cd /data
ls -l
```

### 2. Использование `docker cp`

Если вам нужно скопировать файлы из volume на хост, можно использовать команду `docker cp`. Однако это требует запуска контейнера с доступом к volume.

Запустите контейнер с volume и используйте команду `docker cp` для копирования файлов:

```bash
docker run --name temp-container -v db_data:/data alpine sh -c "while true; do sleep 3600; done"
```

Это создаст контейнер, который просто будет спать, и его можно использовать для копирования данных. Теперь используйте `docker cp` для копирования файлов:

```bash
docker cp temp-container:/data /path/on/host
```

Замените `/path/on/host` на путь, где вы хотите сохранить файлы на хосте.

После копирования не забудьте удалить временный контейнер:

```bash
docker rm -f temp-container
```

### 3. Использование другого контейнера с доступом к volume

Вы также можете использовать контейнер с установленным инструментарием для работы с данными, например, `mysql` для просмотра базы данных. Запустите контейнер MySQL или другой контейнер, подключенный к тому же volume:

```bash
docker run --rm -it --link db:mysql -v db_data:/data mysql:5.7 bash
```

Теперь вы можете использовать утилиты MySQL внутри этого контейнера для работы с данными.

Эти методы помогут вам получить доступ к содержимому volume и просматривать или извлекать файлы из базы данных.


## СЕТЬ(Network)
Создать сеть
docker network create my-network

Удалить сеть
docker network rm my-network

Отразить все сеть
docker network ls

Вся информация о сети
docker network inspect my-network 

Соединиться с сетью
docker network connect my-network my-container

Отсоединиться от сети
docker network disconnect my-network my-container

Пробросить текущую папку в контейнер и работать на хосте, -w working dir, sh shell
docker run -dp 3000:3000 \
-w /app -v "$(pwd):/app" \
node:12-alpine \
sh -c "yarn install && yarn run dev"

Запуск контейнера с присоединением к сети и заведение переменных окружения
docker run -d \
--network todo-app --network-alias mysql \ # (алиас потом сможет резолвить докер для других контейнеров)
-v todo-mysql-data:/var/lib/mysql \ # (автоматом создает named volume)
-e MYSQL_ROOT_PASSWORD=secret \ # (в проде нельзя использовать, небезопасно)
-e MYSQL_DATABASE=todos \ # (в проде юзают файлы внутри конейнера с логинами паролями)
mysql:5.7


Запуск контейнера с приложением
docker run -dp 3000:3000 \
-w /app -v "$(pwd):/app" \
--network todo-app \
-e MYSQL_HOST=mysql \
-e MYSQL_USER=root \
-e MYSQL_PASSWORD=secret \
-e MYSQL_DB=todos \
node:12-alpine \
sh -c "yarn install && yarn run dev"

Переименовать контейнер
docker rename e540a51bc1bb alex_app

Переименовать образ
docker tag e540a51bc1bb alex_app



## DOCKER COMPOSE
```bash
docker-compose down -v	# Это остановит все контейнеры и удалит все тома, включая данные MySQL.

# Запуск контейнеров на основе docker-compose.yml
docker-compose up

# Если хотите запустить контейнеры в фоновом режиме (detached mode)
docker-compose up -d

# Остановка всех контейнеров, созданных через docker-compose
docker-compose down

# Перезапуск контейнеров
docker-compose restart

# Просмотр логов всех контейнеров
docker-compose logs

# Просмотр логов конкретного сервиса
# Замените "service_name" на имя вашего сервиса из docker-compose.yml
docker-compose logs service_name

# Остановка всех контейнеров без их удаления
docker-compose stop

# Запуск ранее остановленных контейнеров
docker-compose start

# Проверка состояния запущенных контейнеров
docker-compose ps

# Построение или пересборка контейнеров (особенно полезно после изменения Dockerfile)
docker-compose build

# Запуск команд внутри контейнера (например, выполнить bash внутри контейнера)
# Замените "service_name" на имя сервиса, а "bash" на нужную команду
docker-compose exec service_name bash

#!/bin/bash

# Запуск команды внутри контейнера без нового процесса
# Используется, если нужно выполнить однократную команду
# Замените "service_name" на имя сервиса и "command" на нужную команду
docker-compose run service_name command

# Остановка и удаление всех контейнеров, сетей, томов и образов, созданных в docker-compose
docker-compose down --volumes --rmi all

# Удаление томов при остановке контейнеров (если тома создавались через compose)
docker-compose down --volumes

# Удаление только контейнеров (не трогая сети, тома и образы)
docker-compose rm

# Удаление конкретного контейнера
# Замените "service_name" на имя вашего сервиса
docker-compose rm service_name

# Создание и запуск контейнеров без запуска приложения
docker-compose create

# Обновление зависимостей в образах и пересборка
docker-compose pull

# Принудительная пересборка контейнеров даже без изменений в Dockerfile
docker-compose build --no-cache

# Просмотр настроек и конфигурации (объединение всех файлов docker-compose)
docker-compose config

# Проверка конфигурации на наличие ошибок
docker-compose config --services

# Обновление или проверка состояния образов для всех сервисов
docker-compose images

# Масштабирование сервиса до нескольких экземпляров контейнера
# Замените "service_name" на имя сервиса и укажите количество экземпляров
docker-compose up --scale service_name=NUM

# Запуск тестов на сервисах с ограничением ресурсов (CPU и память)
# Например, ограничение использования CPU на 50% и памяти до 512M
docker-compose up -d --cpus="0.5" --memory="512m"

# Принудительная остановка всех контейнеров
docker-compose kill

# Остановка контейнеров через определённое количество секунд
docker-compose stop -t SECONDS

# Сохранение состояния контейнера в файл после его остановки
# Используйте для сохранения состояния, чтобы потом восстановить
docker-compose pause
docker-compose unpause  # Восстановление работы

# Изменение имени проекта, если требуется запустить несколько экземпляров в одном окружении
docker-compose -p project_name up

```



шаблон
version: '3'  # Версия синтаксиса Docker Compose

services:  # Определение сервисов приложения
  service1:  # Название первого сервиса
    image: image_name:tag  # Docker образ, используемый для сервиса
    ports:  # Определение портов, которые будут проброшены на хостовую машину
      - "host_port:container_port"  # Пример: "8080:80"
    volumes:  # Определение примонтированных томов
      - "host_path:container_path"  # Пример: "./data:/app/data"
    environment:  # Определение переменных окружения
      - ENV_VAR1=value1  # Пример: "DEBUG=true"
      - ENV_VAR2=value2
    depends_on:  # Определение зависимостей сервисов
      - service2  # Пример: service2
    networks:  # Определение сетей, к которым присоединяется сервис
      - my_network  # Пример: my_network

  service2:  # Название второго сервиса
    build: ./path_to_Dockerfile  # Путь к Dockerfile для сборки образа
    volumes:  # Определение примонтированных томов
      - "host_path:container_path"
    environment:  # Определение переменных окружения
      - ENV_VAR=value
    networks:  # Определение сетей, к которым присоединяется сервис
      - my_network

networks:  # Определение сетей, используемых сервисами
  my_network:  # Название сети
    driver: bridge  # Драйвер сети (по умолчанию bridge)


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

# можем так же удалить все ресурсы докера включая все образы (флаг -a)
docker system prune -a
# либо частично
docker network prune
docker container prune

# удалить все образы по построке
docker rmi $(docker images -q | grep <подстрока>)


# список созданных сетей
docker network ls

# просмотр сведений о сети и запущенных в ней контейнеров. Ищем ip адреса контейнеров
docker network inspect docker_ans_net

```



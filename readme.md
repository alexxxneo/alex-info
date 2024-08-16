
----------------------------------------------
Установка бинарных приложений

Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

Terraform
Копируем бинарник домашнюю директорию /home/alex
Даем права на выполнение chmod +x terraform
Устанавливаем sudo install terraform /usr/local/bin/


------------------------------------------
Замена раскладки на alt shift
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"

переименовать хост
sudo vim /etc/hostname 	задаем в этом файле имя, например alexcomp

------------------------------------------
ПЕРЕИМЕНОВАНИЕ И ПЕРЕМЕЩЕНИ 
Переместить или переименовать файл
$ mv опции файл-источник файл-приемник
mv file1 directory1 	скопировать file1 в директорию directory1 
mv file1 ./directory1 	тоже самое

КОПИРОВАНИЕ
копирование файла в другой файл с указанным именем:
$ cp опции /путь/к/файлу/источнику /путь/к/файлу/назначения
Полное копирование, пример
sudo cp -a /tmp/wordpress/. /var/www/wordpress

УДАЛЕНИЕ
Для удаления директорий, вместе с файлами и поддиректориями используется опция -R, например:
 rm -Rf /home/user/dir
 sudo rm -Rf *
 
 -----------------------------------
РАБОТА С ДИСКОМ

sudo fdisk -l 	список всех дисков
----
МОНТИРОВАНИЕ ПРИ ЗАГРУЗКЕ ОС
vi /etc/fstab
Пример: /dev/sda1     /db     xfs     defaults     0 0
			/dev/sda1 — диск, который мы монтируем
			/db — каталог, в который монтируем диск
			xfs — файловая система
			defaults — стандартные опции. Полный их перечень можно посмотреть на Википеции.
			0 0 — первый отключает создание резервных копий при помощи утилиты dump, второй отключает проверку диска.
Монтируем свой диск D - добавляем строку в файл и потом создаем папку для монтирования
/dev/nvme0n1p5  /home/alex/D ntfs3 defaults 0 0 

-----
Создаем таблицу и раздел

sudo fdisk /dev/sda выбираем для интерактивного взаимодействия нужный диск
	g создаем таблицу GPT
	n создаем новый разделам
	w записываем изменения на диск

Форматируем
sudo mkfs.ntfs -f  -L AlexDisk /dev/sda1 форматируем раздел в ntfs в быстром режиме

sudo mkfs -t ext4  -f -L AlexDisk /dev/sda1 	или форматируем в ext4 в быстром режиме

Монтируем
mkdir /home/alex/flash
sudo mount /dev/sda1 /home/alex/flash/

------------------------------------ 
 rm /home/user/file 	удалить файл


------------------------------------------------------------------------------
ПАКЕТЫ
dpkg -l 						просмотреть все пакеты установленные в системе
dpkg -s имяпакета 				инфа о пакете, зависимостях
dpkg -L имяпакета 				файлы пакета
apt remove –purge имяпакета удаление пакета со всеми настройками
apt remove имяпакета 		удаление пакетов без удаления настроек
apt policy имяпакета 		посмотреть какие версии пакета есть в репозитории
apt install имяпакета=2.0 	установка пакета нужной версии
apt search 	подстрока_пакета	поиск совпадений среди пакетов					

----------------------------------------------------------------------------
ПОИСК

find ~/Downloads -type f -mtime +35 -delete		поиск файлов старше 35 дней и удаление
find / -name “myhelp.txt”
find гдеищем -name “чтоищем”
поиск файлов по имени
	find /var/log -type d такая команда даст нам все поддиректории директории /var/log 
	find /var/log -type f покажет нам все файлы
-----------------------------------------------------------------------------
CRON
crontab -l		просмотреть задачи текущего пользователя
crontab -e  	редактирование задач текущего пользователя
минута час день месяц день_недели /путь/к/исполняемому/файлу
 обязательно enter

----------------------------------------------------------------------------
АРХИВАЦИЯ
7z или zip
7z x файл.zip -o /tmp/ или .7z  распаковать в папку
7z x файл.zip или .7z 			распаковать в текущую папку
7z l файл.7z или .zip 			просмотр архива 
7z a Tutorial.7z tutorial/ 		Добавить в архив

unzip file1.zip					распаковать архив в текущую директорию
unzip -l zipped_file.zip 		просмотреть файлы архива без распаковки
zip output_file.zip input_file	зархивировать 1 файл
zip -r output.zip input_folder	запаковать папку

--------------------------------------------------------------------------
ПРОЦЕССЫ
ps -auxf

ВЫВОД
cat file1 file2  			выведет содержимое 2ух файлов 
cat file1 file2 > file3 	перезапишет file3 объединенным содержимым file1 file2
cat file1 file2 >> file3 	дополнит file3 объединенным содержимым file1 file2

du -sh * 	размеры файлов и папок в текущей директории
free -h 	свободная  оперативная память
df -h 		занятое место на дисках
sudo lsblk	инфа о разделах на диске

-----------------------------------------------------------------------------------------------------
ПРАВА ГРУППЫ ПОЛЬЗОВАТЕЛИ
groups			список групп в которых состоит текущий пользователь
chmod +x myfile  						добавляет права на выполнение для пользователя, группы и остальных 
chmod u=rwx,g=rx,o=r /home/user/dir1	присваивает определенные права
chmod u=rwx,g=rx,o=r dir1 				тут присваиваем нужные права для пользователя, группы и остальных

$ chown пользователь опции /путь/к/файлу
sudo chown alex:alex terraform			сменить пользователя и группу для файла или папки
sudo chown -R alex:alex terraform			сменить пользователя и группу для файла или папки рекурсивно
-----------------------------------------------------------------------------------------------------------------
GIT

GIT
https://habr.com/ru/companies/ruvds/articles/599929/
https://proglib.io/p/git-for-half-an-hour
https://contentim.ru/post/git

Коммиты
git commit -m "Name of commit"    # зафиксировать в коммите проиндексированные изменения (закоммитить), добавить сообщение


.gitignore тоже добавляется в индекс
Добавляются к примеру:
*.log
/storage
/config/database.php
/config/app.php
.htaccess
/node_modules
/themes/sambiahotel/content

git rm —cached filename удалить из отслеживания после добавления в .gitignore
	—cached без удаления из файловой системы


Ветки
git status показывает файлы находящиеся в индексе,  на какой ветке в данный момент находимся и последние коммиты
git log история коммитов
git checkout –b dev1 создать ветку с именем dev1, одновременно переключившись на нее
git branch  посмотреть список доступных веток. Зеленый цвет обозначает что это локальная ветка
git branch -a посмотреть список доступных веток, включая в удаленных репозиториях, помечены красным
git branch new-branch-name создать новую ветку

удаленные репозитории
git remote -v список удаленных репозиториев

git push origin master     # отправить в удалённый репозиторий (с сокр. именем origin) данные своей ветки master

когда на локальном есть ветка а на удаленном нет соответствующей
git push –u origin dev1 отправляем именно ветку dev1 в удаленный репозиторий origin 
git push –u origin main отплавяем ветку main в удаленный репозиторий origin
	origin указатель на удаленный репозиторий
	-u отправить в ветку с таким же названием как локальная и создать связь между этими ветками, в ином случае выдаст ошибку если на удаленном нет ветки с соответствующим именем. После этого можно просто использовать находясь на данной ветке, просто git push


git pull origin main  получить изменения с удаленного репозитория origin и его ветки main

# указана последовательность действий:
# создана директория проекта, мы в ней
git init                      # создаём репозиторий в этой директории
touch readme.md               # создаем файл readme.md
git add readme.md             # добавляем файл в индекс
git commit -m "Старт"         # создаем коммит
git remote add origin https://github.com:nicothin/test.git # добавляем предварительно созданный пустой удаленный репозиторий

git push -u origin main     # отправляем данные из локального репозитория в удаленный (в ветку master)

Слияние веток
git merge new-branch вливаем ветку new-branch  в текущую ветку, в которой находимся

Откладывание изменений
 
git stash  отложить пак изменений
git stash list просмотреть список отложенных паков изменений
git stash pop вернуть последний пак изменений

Отмена изменений
Не или из стейджа
git diff filename просмотреть сделанные изменения. Между файлом и стейджом
git diff просмотреть изменения всех файлов. Между файлом и стейджом

git restore filename безвозвратное удаление незакомиченных изменений в конкретном файле
git restore –staged безвозвратное удаление не закомиченных изменений в конкретном файле из стейджа
git reset --hard безвозвратно удаляет все незакомиченные изменения во всех файлах, даже если они не были добавлены в стейдж 
git clean -f удаляет все новые неотслеживаемые незакомиченные изменения
git rm --cached
Отмена закомиченных изменений
git checkout commit_hash filename возвращает файл в состояние на указанный коммит и сразу добавляется в стейдж…. т.е  восстановить в рабочей директории указанный файл на момент указанного коммита (и добавить это изменение в индекс) (git reset index.html для удаления из индекса, но сохранения изменений в файле. git restore –staged для удаления изменений  и удаление из индекса )
git revert commit_name отменяет указанный коммит, при этом все последующие коммиты остаются без изменений
git revert --no-commit commit_name  можно отменить несколько коммитов подряд, не делая каждый раз коммит и сделав единый коммит  в конце

Сброс коммитов
git reset --soft commit_name  если указываем предпоследний коммит, то мы сбросим изменения последнего коммита и отправим их в индекс
git reset –mixed то же что и мягкий режим, но не добавляем в индекc Можно просто писать git reset без этого параметра, т.к. он по умолчанию идет
git reset HEAD~1 сбрасывает один последний коммит. Если другая цифра, то соотвественно
 git reset –hard удаляет все изменения и коммиты позднее указанного коммита
 git commit --amend -m редактирование комментария последнего коммита
git commit --amend --no-edit редактирование файлов последнего коммита


 


git mv filename1 filename2 переименование файла




------------------------------------------------------------------------------------------------------------------
DOCKER

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


------------------------------------------------------------------------------------------------


Docker
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
--------------------------------------------------
Хранилище (Volumes)

Создание тома 					docker volume create my_volume
Выяснить информацию о томах 	docker volume ls
Исследовать конкретный том  	docker volume inspect my_volume
Удаление тома 					docker volume rm my_volume
Удалить все тома 				docker volume prune
Очистка peсурсов Docker 		docker system prune

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


-----------------------------------------------
СЕТЬ(Network)
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
---------------------------------------------------------
DOCKER COMPOSE

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


-------------------------------------------------------------------------------------------
KUBERNETES

ИНСТРУКЦИИ KUBECTL
Основные команды

Общая информация о кластере:
kubectl cluster-info

Информация о компонентах кластера:
kubectl get componentstatuses

Список всех узлов (нод):
kubectl get nodes

Подробная информация о ноде:
kubectl describe node <node_name>

Работа с Namespaces

Список всех namespaces:
kubectl get namespaces

Создание namespace:
kubectl create namespace <namespace_name>

Удаление namespace:
kubectl delete namespace <namespace_name>

Работа с Pods

Список всех подов:
kubectl get pods

Список подов в указанном namespace:
kubectl get pods -n <namespace>

Подробная информация о поде:
kubectl describe pod <pod_name>

Логи пода:
kubectl logs <pod_name>

Запуск шелла в контейнере пода:
kubectl exec -it <pod_name> -- /bin/bash

Работа с Deployments

Список всех deployments:
kubectl get deployments

Создание deployment из YAML файла:
kubectl apply -f <file.yaml>

Обновление deployment:
kubectl set image deployment/<deployment_name> <container_name>=<new_image>

Откат к предыдущей версии deployment:
kubectl rollout undo deployment/<deployment_name>

Работа с Services

Список всех сервисов:
kubectl get services

Подробная информация о сервисе:
kubectl describe service <service_name>

Работа с ConfigMaps и Secrets

Список всех ConfigMaps:
kubectl get configmaps

Создание ConfigMap из файла:
kubectl create configmap <configmap_name> --from-file=<file_path>

Список всех Secrets:
kubectl get secrets

Создание Secret из файла:
kubectl create secret generic <secret_name> --from-file=<file_path>

Работа с RBAC (Role-Based Access Control)

Список всех ролей:
kubectl get roles

Список всех rolebindings:
kubectl get rolebindings

Создание роли из YAML файла:
kubectl apply -f <role.yaml>

Создание привязки роли (rolebinding) из YAML файла:
kubectl apply -f <rolebinding.yaml>

Полезные опции

Переключение namespace:
kubectl config set-context --current --namespace=<namespace>

Фильтрация вывода по меткам (labels):
kubectl get pods -l <label_selector>

Сортировка вывода:
kubectl get pods --sort-by=.metadata.name

Вывод в формате YAML/JSON:
kubectl get pods -o yaml
kubectl get pods -o json



PODS

ИНСТРУКЦИИ. Создание и управление Pods

Создание пода из YAML файла:
kubectl apply -f <file.yaml>

Удаление пода:
kubectl delete pod <pod_name>

Перезапуск пода:
kubectl delete pod <pod_name> --grace-period=0 --force

Список подов:
kubectl get pods

Список подов в указанном namespace:
kubectl get pods -n <namespace>

Подробная информация о поде:
kubectl describe pod <pod_name>

Логи пода:
kubectl logs <pod_name>

Логи конкретного контейнера в поде:
kubectl logs <pod_name> -c <container_name>

Потоковые логи пода:
kubectl logs -f <pod_name>

Потоковые логи конкретного контейнера в поде:
kubectl logs -f <pod_name> -c <container_name>

Запуск шелла в контейнере пода:
kubectl exec -it <pod_name> -- /bin/bash

Выполнение команды в контейнере пода:
kubectl exec <pod_name> -- <command>

Проброс порта из пода на локальную машину:
kubectl port-forward <pod_name> <local_port>:<remote_port>

Копирование файлов из пода на локальную машину:
kubectl cp <pod_name>:<path/to/file> <local_path>

Копирование файлов с локальной машины в под:
kubectl cp <local_path> <pod_name>:<path/to/file>

Фильтрация подов по меткам (labels):
kubectl get pods -l <label_selector>

Сортировка вывода подов:
kubectl get pods --sort-by=.metadata.name

Вывод списка подов в формате YAML:
kubectl get pods -o yaml

Вывод списка подов в формате JSON:
kubectl get pods -o json

----------------------------------------------------------------
TERRAFORM

terraform validate && terraform plan 	проверка все конфигурационных файлов tf
terraform apply 						применение всех файлов и создание ресурсов в облаке
terraform destroy						удаление всех ресурсов из облака
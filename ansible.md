# установка
https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu

```bash
$ UBUNTU_CODENAME=jammy

$ wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg

$ echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list

$ sudo apt update && sudo apt install ansible
```


# ТЕОРИЯ

Ansible — это инструмент автоматизации, который позволяет управлять конфигурацией, развертыванием и оркестрацией серверов и приложений. Ansible использует YAML-файлы, называемые плейбуками (playbooks), для определения задач, которые должны быть выполнены на удалённых хостах. Он взаимодействует с узлами через SSH, что делает его агент-независимым и лёгким в использовании.

Ниже приведён список наиболее часто используемых команд Ansible с примерами и подробными описаниями.

### 1. `ansible`

Команда `ansible` используется для выполнения одноразовых задач на удалённых узлах, таких как проверка доступности или запуск команды.

**Синтаксис:**
```bash
ansible <host-pattern> -m <module> -a "<arguments>"
```

**Примеры:**

1. **Проверка доступности узлов (ping):**
   ```bash
   ansible all -m ping
   ```
   Проверяет доступность всех узлов, определённых в инвентарном файле.

2. **Выполнение команды на удалённых узлах:**
   ```bash
   ansible webservers -m command -a "uptime"
   ```
   Выполняет команду `uptime` на всех узлах, принадлежащих группе `webservers`.

3. **Создание файла на удалённых узлах:**
   ```bash
   ansible webservers -m file -a "dest=/tmp/testfile state=touch"
   ```
   Создаёт пустой файл `/tmp/testfile` на всех узлах группы `webservers`.

### 2. `ansible-playbook`

Команда `ansible-playbook` используется для выполнения плейбуков, которые представляют собой наборы задач, определённых в формате YAML.

**Синтаксис:**
```bash
ansible-playbook <playbook.yml>
```

**Примеры:**

1. **Запуск плейбука:**
   ```bash
   ansible-playbook site.yml
   ```
   Выполняет плейбук `site.yml`, который содержит задачи для конфигурации узлов.

2. **Запуск плейбука с указанием конкретных узлов:**
   ```bash
   ansible-playbook site.yml --limit webservers
   ```
   Выполняет плейбук `site.yml` только для узлов, принадлежащих группе `webservers`.

3. **Запуск плейбука с отображением отладочной информации:**
   ```bash
   ansible-playbook site.yml -v
   ```
   Выполняет плейбук `site.yml` с базовой отладочной информацией. Для более подробной отладки можно использовать `-vv` или `-vvv`.

4. **Проверка плейбука без выполнения (режим проверки):**
   ```bash
   ansible-playbook site.yml --check
   ```
   Выполняет "сухой прогон" плейбука `site.yml`, показывая, какие изменения будут внесены, без фактического их выполнения.

### 3. `ansible-vault`

Команда `ansible-vault` используется для шифрования и дешифрования данных, таких как файлы с паролями или плейбуки.

**Синтаксис:**
```bash
ansible-vault <subcommand> [options]
```

**Примеры:**

1. **Создание зашифрованного файла:**
   ```bash
   ansible-vault create secret.yml
   ```
   Создаёт новый файл `secret.yml` и шифрует его.

2. **Редактирование зашифрованного файла:**
   ```bash
   ansible-vault edit secret.yml
   ```
   Открывает зашифрованный файл `secret.yml` для редактирования.

3. **Дешифрование файла:**
   ```bash
   ansible-vault decrypt secret.yml
   ```
   Дешифрует файл `secret.yml`.

4. **Шифрование существующего файла:**
   ```bash
   ansible-vault encrypt vars.yml
   ```
   Шифрует существующий файл `vars.yml`.

### 4. `ansible-galaxy`

Команда `ansible-galaxy` используется для загрузки и управления ролями, доступными в Ansible Galaxy — официальном репозитории ролей.

**Синтаксис:**
```bash
ansible-galaxy <subcommand> [options]
```

**Примеры:**

1. **Установка роли из Ansible Galaxy:**
   ```bash
   ansible-galaxy install username.rolename
   ```
   Устанавливает роль `rolename` от пользователя `username`.

2. **Создание новой роли:**
   ```bash
   ansible-galaxy init myrole
   ```
   Создаёт структуру для новой роли `myrole`.

3. **Удаление роли:**
   ```bash
   ansible-galaxy remove username.rolename
   ```
   Удаляет установленную роль `rolename`.

### 5. `ansible-config`

Команда `ansible-config` используется для управления и просмотра конфигурации Ansible.

**Синтаксис:**
```bash
ansible-config <subcommand> [options]
```

**Примеры:**

1. **Просмотр текущей конфигурации:**
   ```bash
   ansible-config view
   ```
   Показывает текущие настройки конфигурации Ansible.

2. **Проверка файла конфигурации:**
   ```bash
   ansible-config dump --only-changed
   ```
   Показывает только изменённые параметры конфигурации.

### 6. `ansible-inventory`

Команда `ansible-inventory` используется для управления и отображения инвентаря Ansible.

**Синтаксис:**
```bash
ansible-inventory [options]
```

**Примеры:**

1. **Показать инвентарь в виде JSON:**
   ```bash
   ansible-inventory --list -y
   ```
   Выводит инвентарь в формате JSON.

2. **Проверка синтаксиса инвентарного файла:**
   ```bash
   ansible-inventory --graph
   ```
   Отображает граф зависимости инвентаря.

### 7. `ansible-doc`

Команда `ansible-doc` используется для получения документации по модулям Ansible.

**Синтаксис:**
```bash
ansible-doc [options] <module>
```

**Примеры:**

1. **Показать документацию для модуля `file`:**
   ```bash
   ansible-doc file
   ```
   Отображает документацию для модуля `file`.

2. **Список всех доступных модулей:**
   ```bash
   ansible-doc -l
   ```
   Выводит список всех доступных модулей Ansible.

### 8. `ansible-pull`

Команда `ansible-pull` используется для переворота модели управления: вместо того чтобы Ansible управлял узлами, узлы сами могут "подтягивать" плейбуки с сервера.

**Синтаксис:**
```bash
ansible-pull -U <repository_url> [options]
```

**Примеры:**

1. **Запуск плейбука из репозитория Git:**
   ```bash
   ansible-pull -U https://github.com/username/repo.git
   ```
   Выполняет плейбук из репозитория Git на локальном узле.

### 9. `ansible-playbook --syntax-check`

Команда `ansible-playbook --syntax-check` используется для проверки синтаксиса плейбука без его выполнения.

**Синтаксис:**
```bash
ansible-playbook --syntax-check <playbook.yml>
```

**Примеры:**

1. **Проверка синтаксиса плейбука:**
   ```bash
   ansible-playbook --syntax-check site.yml
   ```
   Проверяет плейбук `site.yml` на синтаксические ошибки.

### 10. `ansible-playbook --list-tasks`

Команда `ansible-playbook --list-tasks` используется для вывода списка задач в плейбуке без их выполнения.

**Синтаксис:**
```bash
ansible-playbook --list-tasks <playbook.yml>
```

**Примеры:**

1. **Вывод списка задач в плейбуке:**
   ```bash
   ansible-playbook --list-tasks site.yml
   ```
   Выводит список всех задач, определённых в плейбуке `site.yml`.

### Заключение

Ansible предоставляет мощный набор инструментов для автоматизации управления ИТ-инфраструктурой. Знание команд Ansible и их возможностей позволяет эффективно управлять конфигурацией и развертыванием в различных окружениях.

# PLAYBOOKS ПЛЕЙБУКИ

Ansible плейбуки — это YAML-файлы, которые определяют набор задач для автоматизации управления серверами, приложениями и сетями. Вот несколько самых популярных плейбуков, которые часто используются в повседневной работе DevOps инженеров и системных администраторов.

### 1. Установка и настройка веб-сервера (Nginx)

Этот плейбук используется для установки и настройки Nginx на удалённом сервере.

```yaml
---
- name: Установка и настройка Nginx
  hosts: webservers
  become: true
  tasks:
    - name: Убедиться, что Nginx установлен
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Убедиться, что Nginx запущен и включен
      service:
        name: nginx
        state: started
        enabled: true

    - name: Развернуть конфигурационный файл Nginx
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        mode: '0644'
      notify:
        - Перезапустить Nginx

  handlers:
    - name: Перезапустить Nginx
      service:
        name: nginx
        state: restarted
```

**Описание:**
- **hosts:** Группа серверов `webservers`, на которых будет выполняться плейбук.
- **tasks:** Список задач, таких как установка Nginx, включение сервиса и развёртывание конфигурационного файла.
- **handlers:** Используются для перезапуска Nginx, если конфигурационный файл был изменён.

### 2. Установка и настройка MySQL

Плейбук для установки MySQL и настройки баз данных и пользователей.

```yaml
---
- name: Установка и настройка MySQL
  hosts: dbservers
  become: true
  vars:
    mysql_root_password: 'secure_password'
    mysql_user: 'myuser'
    mysql_user_password: 'user_password'
    mysql_database: 'mydatabase'

  tasks:
    - name: Установить MySQL
      apt:
        name: mysql-server
        state: present
        update_cache: yes

    - name: Обеспечить наличие базы данных
      mysql_db:
        name: "{{ mysql_database }}"
        state: present

    - name: Обеспечить наличие пользователя базы данных
      mysql_user:
        name: "{{ mysql_user }}"
        password: "{{ mysql_user_password }}"
        priv: "{{ mysql_database }}.*:ALL"
        state: present
```

**Описание:**
- **vars:** Переменные, определяющие пароль root, имя пользователя, пароль пользователя и имя базы данных.
- **tasks:** Установка MySQL, создание базы данных и пользователя с необходимыми привилегиями.

### 3. Обновление всех пакетов на серверах

Плейбук для обновления всех установленных пакетов до их последних версий.

```yaml
---
- name: Обновление всех пакетов на серверах
  hosts: all
  become: true
  tasks:
    - name: Обновить все пакеты до последних версий
      apt:
        upgrade: dist
        update_cache: yes
```

**Описание:**
- **hosts:** Все серверы, определённые в инвентаре.
- **tasks:** Выполнение обновления всех пакетов.

### 4. Развёртывание приложения на Node.js

Плейбук для установки Node.js и развёртывания приложения.

```yaml
---
- name: Развёртывание Node.js приложения
  hosts: appservers
  become: true
  vars:
    nodejs_version: "14.x"
    app_directory: "/var/www/myapp"

  tasks:
    - name: Добавить репозиторий Node.js
      apt_repository:
        repo: "deb https://deb.nodesource.com/node_{{ nodejs_version }} {{ ansible_distribution_release }} main"
        state: present

    - name: Установить Node.js
      apt:
        name: nodejs
        state: present

    - name: Создать директорию приложения
      file:
        path: "{{ app_directory }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Скопировать файлы приложения
      copy:
        src: /path/to/local/app/
        dest: "{{ app_directory }}"
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Установить зависимости приложения
      npm:
        path: "{{ app_directory }}"
        state: present
```

**Описание:**
- **vars:** Переменные для версии Node.js и директории приложения.
- **tasks:** Добавление репозитория Node.js, установка Node.js, создание директории для приложения, копирование файлов приложения и установка зависимостей через `npm`.

### 5. Настройка брандмауэра (firewall) с UFW

Плейбук для настройки UFW (Uncomplicated Firewall) на серверах.

```yaml
---
- name: Настройка UFW
  hosts: all
  become: true
  tasks:
    - name: Установить UFW
      apt:
        name: ufw
        state: present
        update_cache: yes

    - name: Открыть SSH
      ufw:
        rule: allow
        name: OpenSSH

    - name: Открыть HTTP и HTTPS
      ufw:
        rule: allow
        port: "80,443"
        proto: tcp

    - name: Включить UFW
      ufw:
        state: enabled
```

**Описание:**
- **tasks:** Установка UFW, открытие портов для SSH, HTTP и HTTPS, и включение UFW.

### 6. Настройка времени на серверах (NTP)

Плейбук для установки и настройки Network Time Protocol (NTP) для синхронизации времени.

```yaml
---
- name: Настройка времени через NTP
  hosts: all
  become: true
  tasks:
    - name: Установить NTP
      apt:
        name: ntp
        state: present
        update_cache: yes

    - name: Настроить NTP
      template:
        src: templates/ntp.conf.j2
        dest: /etc/ntp.conf
      notify:
        - Перезапустить NTP

  handlers:
    - name: Перезапустить NTP
      service:
        name: ntp
        state: restarted
```

**Описание:**
- **tasks:** Установка NTP и настройка конфигурационного файла через шаблон.
- **handlers:** Перезапуск NTP, если конфигурационный файл был изменён.

### 7. Управление пользователями

Плейбук для создания и удаления пользователей на серверах.

```yaml
---
- name: Управление пользователями
  hosts: all
  become: true
  tasks:
    - name: Создать пользователя
      user:
        name: john
        state: present
        groups: "sudo"
        append: yes

    - name: Удалить пользователя
      user:
        name: jane
        state: absent
```

**Описание:**
- **tasks:** Создание пользователя с именем `john` и добавление его в группу `sudo`, а также удаление пользователя `jane`.


# ПРАКТИКА


## ansible.cfg

 [defaults]  
 host_key_checking = false  
 inventory         = ./hosts.txt  
 ansible_become_pass = 123  # указываем пароль от sudo

 ## inventory

[staging_DB]
172.18.0.2     

[staging_WEB]
172.18.0.3    

[staging_APP]
172.18.0.4   


[all:vars]
ansible_user=user
ansible_ssh_private_key=/home/alex/.ssh/id_rsa

# ansible.cfg

 [defaults]  
 host_key_checking = false  # отключаем подверждение подключения
 inventory         = ./hosts.txt  
 ansible_become_pass = 123  # указываем пароль от sudo

 # inventory

[staging_DB]
172.18.0.2     

[staging_WEB]
172.18.0.3    

[staging_APP]
172.18.0.4   


[all:vars]
ansible_user=user
ansible_ssh_private_key=/home/alex/.ssh/id_rsa


## ad-hoc команды  

ansible all -m shell -a "ls /etc"  
-m ключ, что указываем это модуль  
-a ключ, что указываем аргумент  
  




Копирование фала на все сервера  
ansible all -m copy -a "src=/home/alex/privet.txt dest=/home/user"  
ansible all -m copy -a "src=/home/alex/privet.txt dest=/home/ mode=777" -b  
+ -b этот параметр указывает, что мы копируем файл в режиме sudo. при необходимости пароль от sudo должен быть указан в переменных подключения **ansible_become_pass=123**  
  
скачать файл из интернета на все сервера  в режиме sudo  
ansible all -m get_url -a "url=https://example.com/file.txt dest=/home" -b  
  
просмотр
ansible all -m shell -a "ls -la /home" 

удалить ранее созданный файл
ansible all -m file -a "path=/home/privet.txt state=absent" -b
+ state=absent: Указывает, что файл по указанному пути должен быть удален, если он существует. Если файла нет, то ничего не происходит.

### подробнее о модуле file
Модуль Ansible `file` предоставляет различные атрибуты для управления файлами и директориями на удалённых хостах. Эти атрибуты позволяют создавать и удалять файлы и каталоги, управлять их правами доступа, владельцами и группами, а также устанавливать специальные атрибуты, такие как символьные ссылки или режимы доступа.

Вот список наиболее часто используемых атрибутов модуля `file`:

### Основные атрибуты модуля `file`

1. **`path`**: 
   - **Описание**: Указывает путь к файлу или директории, над которым будут выполняться действия.
   - **Пример**: `path=/home/user/testfile`

2. **`state`**: 
   - **Описание**: Определяет, в каком состоянии должен находиться файл или директория.
   - **Возможные значения**:
     - `absent`: Удаляет файл или директорию, если они существуют.
     - `directory`: Указывает, что по указанному пути должна существовать директория.
     - `file`: Указывает, что по указанному пути должен существовать файл.
     - `link`: Создаёт символическую ссылку.
     - `hard`: Создаёт жёсткую ссылку.
     - `touch`: Обновляет время доступа и изменения для файла, создаёт файл, если он не существует.

3. **`owner`**: 
   - **Описание**: Определяет владельца файла или директории.
   - **Пример**: `owner=root`

4. **`group`**: 
   - **Описание**: Определяет группу владельцев файла или директории.
   - **Пример**: `group=admin`

5. **`mode`**: 
   - **Описание**: Устанавливает права доступа к файлу или директории. Может использоваться как в символьной форме (`u=rwx,g=rx,o=r`), так и в числовой форме (`0755`).
   - **Пример**: `mode=0755`

6. **`recurse`**: 
   - **Описание**: Если установлено в `yes`, то рекурсивно применяет изменение прав доступа, владельца или группы для всех файлов и директорий внутри указанного каталога.
   - **Пример**: `recurse=yes`

7. **`src`**: 
   - **Описание**: Используется вместе с `state=link` или `state=hard` для создания символической или жёсткой ссылки. Указывает на целевой путь для ссылки.
   - **Пример**: `src=/path/to/source`

8. **`force`**: 
   - **Описание**: Используется для принудительного выполнения некоторых операций, например, замены символической ссылки. Может быть полезно в сочетании с `state=link`.
   - **Пример**: `force=yes`

9. **`seuser`**, **`serole`**, **`setype`**, **`selevel`**: 
   - **Описание**: Эти атрибуты используются для управления атрибутами SELinux (если SELinux включен на целевой системе).
   - **Примеры**:
     - `seuser=system_u`
     - `serole=object_r`
     - `setype=httpd_sys_content_t`
     - `selevel=s0`

10. **`follow`**:
    - **Описание**: Определяет, должны ли обрабатываться символические ссылки. По умолчанию `no`, что означает, что символические ссылки не обрабатываются.
    - **Пример**: `follow=yes`

### Примеры использования модуля `file`

1. **Создание каталога с определенными правами и владельцем:**

   ```yaml
   - name: Создать каталог /home/user/testdir
     ansible.builtin.file:
       path: /home/user/testdir
       state: directory
       owner: user
       group: user
       mode: '0755'
   ```

2. **Удаление файла:**

   ```yaml
   - name: Удалить файл /tmp/oldfile.txt
     ansible.builtin.file:
       path: /tmp/oldfile.txt
       state: absent
   ```

3. **Создание символической ссылки:**

   ```yaml
   - name: Создать символическую ссылку /home/user/linkfile, указывающую на /home/user/originalfile
     ansible.builtin.file:
       src: /home/user/originalfile
       path: /home/user/linkfile
       state: link
   ```

4. **Обновление времени доступа и изменения для существующего файла или создание нового файла:**

   ```yaml
   - name: Обновить время доступа для файла /home/user/updatefile.txt или создать файл, если его нет
     ansible.builtin.file:
       path: /home/user/updatefile.txt
       state: touch
   ```

Эти атрибуты и примеры демонстрируют, как можно использовать модуль `file` в Ansible для выполнения различных операций по управлению файлами и директориями на удалённых системах.
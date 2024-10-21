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


 **Синтаксис:**
```bash
ansible <host-pattern> -m <module> -a "<arguments>"
```
## 1. `ansible`
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


## 2. `ansible-playbook`

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

## 3. `ansible-vault`

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

## 4. `ansible-galaxy`

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

## 5. `ansible-config`

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

## 6. `ansible-inventory`

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

## 7. `ansible-doc`

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

## 8. `ansible-pull`

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

## 9. `ansible-playbook --syntax-check`

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

## 10. `ansible-playbook --list-tasks`

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


## State в разных модулях

В Ansible параметр `state` используется для указания желаемого состояния ресурса (файла, пакета, службы и т.д.). Разные модули поддерживают различные значения для `state`, поэтому набор допустимых вариантов зависит от модуля. Вот некоторые из наиболее распространённых вариантов `state`:

### 1. **Модули для управления пакетами**
Модули: `yum`, `apt`, `dnf`, `pip`, и другие.

- **present**: Указывает, что пакет должен быть установлен.
  ```yaml
  - name: Ensure Apache is installed
    yum:
      name: httpd
      state: present
  ```

- **absent**: Указывает, что пакет должен быть удалён.
  ```yaml
  - name: Ensure Apache is removed
    apt:
      name: apache2
      state: absent
  ```

- **latest**: Указывает, что должен быть установлен последний доступный пакет.
  ```yaml
  - name: Ensure Apache is at latest version
    yum:
      name: httpd
      state: latest
  ```

- **installed**: Синоним для `present`.

- **removed**: Синоним для `absent`.

### 2. **Модули для управления файлами и директориями**
Модули: `file`, `copy`, `template`, и другие.

- **file**: Указывает, что объект должен быть файлом.
  ```yaml
  - name: Ensure /etc/myconfig is a file
    file:
      path: /etc/myconfig
      state: file
  ```

- **directory**: Указывает, что объект должен быть директорией.
  ```yaml
  - name: Ensure /data is a directory
    file:
      path: /data
      state: directory
  ```

- **absent**: Указывает, что файл или директория должны быть удалены.
  ```yaml
  - name: Ensure /tmp/oldfile is absent
    file:
      path: /tmp/oldfile
      state: absent
  ```

- **touch**: Обновляет время доступа и модификации файла (или создает его, если он не существует).
  ```yaml
  - name: Touch a file to update timestamp
    file:
      path: /tmp/somefile
      state: touch
  ```

- **link**: Указывает, что объект должен быть символической ссылкой.
  ```yaml
  - name: Ensure /tmp/symlink points to /etc/myconfig
    file:
      src: /etc/myconfig
      dest: /tmp/symlink
      state: link
  ```

- **hard**: Указывает, что объект должен быть жёсткой ссылкой.
  ```yaml
  - name: Create a hard link to /etc/myconfig
    file:
      src: /etc/myconfig
      dest: /tmp/hardlink
      state: hard
  ```

### 3. **Модули для управления службами**
Модули: `service`, `systemd`, и другие.

- **started**: Служба должна быть запущена.
  ```yaml
  - name: Ensure Apache is started
    service:
      name: httpd
      state: started
  ```

- **stopped**: Служба должна быть остановлена.
  ```yaml
  - name: Ensure Apache is stopped
    service:
      name: httpd
      state: stopped
  ```

- **restarted**: Служба должна быть перезапущена.
  ```yaml
  - name: Ensure Apache is restarted
    service:
      name: httpd
      state: restarted
  ```

- **reloaded**: Служба должна перезагрузить конфигурацию без полной перезагрузки.
  ```yaml
  - name: Reload Apache configuration
    service:
      name: httpd
      state: reloaded
  ```

### 4. **Модули для управления пользователями и группами**
Модули: `user`, `group`.

- **present**: Указывает, что пользователь или группа должны существовать.
  ```yaml
  - name: Ensure user 'deploy' exists
    user:
      name: deploy
      state: present
  ```

- **absent**: Указывает, что пользователь или группа должны быть удалены.
  ```yaml
  - name: Ensure user 'olduser' is absent
    user:
      name: olduser
      state: absent
  ```

### 5. **Модули для управления виртуальными машинами и контейнерами**
Модули: `docker_container`, `virt`, и другие.

- **started**: Контейнер или ВМ должны быть запущены.
  ```yaml
  - name: Ensure Docker container is started
    docker_container:
      name: mycontainer
      state: started
  ```

- **stopped**: Контейнер или ВМ должны быть остановлены.
  ```yaml
  - name: Ensure Docker container is stopped
    docker_container:
      name: mycontainer
      state: stopped
  ```

- **present**: Контейнер или ВМ должны существовать (но не обязательно быть запущенными).
  ```yaml
  - name: Ensure Docker container exists
    docker_container:
      name: mycontainer
      state: present
  ```

- **absent**: Контейнер или ВМ должны быть удалены.
  ```yaml
  - name: Ensure Docker container is removed
    docker_container:
      name: mycontainer
      state: absent
  ```

### 6. **Модули для управления источниками репозиториев**
Модули: `git`, `svn`, и другие.

- **present**: Репозиторий должен быть клонирован или обновлён.
  ```yaml
  - name: Clone Git repository
    git:
      repo: 'https://github.com/myrepo.git'
      dest: '/path/to/destination'
      state: present
  ```

- **absent**: Указывает, что репозиторий должен быть удалён.
  ```yaml
  - name: Remove Git repository
    git:
      dest: '/path/to/destination'
      state: absent
  ```

### 7. **Модули для управления конфигурациями сети**
Модули: `network`, `nmcli`, и другие.

- **up**: Сетевой интерфейс должен быть активен.
  ```yaml
  - name: Bring up network interface
    nmcli:
      conn_name: eth0
      state: up
  ```

- **down**: Сетевой интерфейс должен быть отключен.
  ```yaml
  - name: Bring down network interface
    nmcli:
      conn_name: eth0
      state: down
  ```

## PLAYBOOKS ПЛЕЙБУКИ ПРИМЕРЫ

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

## Роли
В Ansible роли (roles) организуют задачи и переменные в отдельные, легко управляемые компоненты. Роль Ansible состоит из различных каталогов, и каждый раздел выполняет свою функцию, что делает управление инфраструктурой модульным и переиспользуемым.

### Основные разделы роли Ansible:

1. **`tasks/`**: 
   - Этот каталог содержит основной список задач, которые будут выполняться при вызове роли. 
   - Основной файл здесь — `main.yml`, который запускает задачи. Дополнительные задачи могут быть разделены на несколько файлов и подключены через `include` или `import_tasks`.
   
   **Пример:**
   ```yaml
   ---
   - name: Install Nginx
     apt:
       name: nginx
       state: present
   ```

2. **`handlers/`**:
   - В этом каталоге находятся хэндлеры, которые запускаются по уведомлениям из задач (например, перезапуск службы после установки или изменения конфигурации).
   - Основной файл — `main.yml`. Хэндлеры используются для запуска после успешного изменения состояния задачи.

   **Пример:**
   ```yaml
   ---
   - name: Restart Nginx
     service:
       name: nginx
       state: restarted
   ```

3. **`templates/`**:
   - Этот каталог содержит шаблоны Jinja2, которые могут быть использованы для создания файлов конфигурации с динамическими переменными.
   - Ansible копирует эти шаблоны на хосты, заменяя переменные значениями, определенными в playbook или инвентаре.

   **Пример шаблона (nginx.conf.j2):**
   ```nginx
   server {
       listen 80;
       server_name {{ domain }};
       root {{ document_root }};
   }
   ```

4. **`files/`**:
   - Каталог для статических файлов, которые необходимо скопировать на удалённые хосты без изменений. Это могут быть бинарные файлы, скрипты и другие ресурсы, которые не требуют динамического редактирования.

   **Пример использования:**
   ```yaml
   - name: Copy myfile
     copy:
       src: myfile
       dest: /etc/myfile
   ```

5. **`vars/`**:
   - Этот каталог содержит переменные, которые можно использовать в роли. Файл `main.yml` содержит переменные с жестко заданными значениями. Эти переменные могут использоваться в задачах, шаблонах и других разделах роли.

   **Пример:**
   ```yaml
   ---
   domain: example.com
   document_root: /var/www/html
   ```

6. **`defaults/`**:
   - Этот каталог похож на `vars/`, но значения здесь имеют низкий приоритет, и их можно переопределить через playbook, инвентарь или переменные командной строки.
   - Используются для определения значений по умолчанию.

   **Пример:**
   ```yaml
   ---
   nginx_version: 1.14
   ```

7. **`meta/`**:
   - Здесь хранятся метаданные роли, такие как зависимости от других ролей, минимальная версия Ansible, поддерживаемые операционные системы и другие характеристики.
   - Файл `main.yml` может содержать ключ `dependencies`, где перечисляются роли, которые должны быть выполнены до текущей роли.

   **Пример:**
   ```yaml
   ---
   dependencies:
     - { role: common, some_var: some_value }
   ```

8. **`tests/`**:
   - В этом каталоге находятся тестовые playbook'и, которые можно использовать для проверки роли. Обычно здесь есть файл `test.yml`, где содержатся тестовые сценарии для запуска и тестирования роли.

9. **`roles/`**:
   - Этот раздел используется для вложенных ролей, если роль имеет зависимость или требует выполнения другой роли.
   
10. **`inventory/`**:
    - Необязательный раздел, в котором может храниться инвентарь (хосты и группы хостов) для конкретной роли.

11. **`README.md`**:
    - Документ, который описывает роль, её использование, зависимости и переменные. Полезно для других пользователей или разработчиков, чтобы понять, как работает роль и как её использовать.

#### Дополнительные разделы (не всегда используются):
- **`facts/`**: Могут использоваться для создания и сохранения пользовательских фактов.
- **`lookups/`**: Хранит кастомные модули для выполнения пользовательских запросов с хостов или других источников данных.
- **`plugins/`**: Для пользовательских плагинов, таких как модули, фильтры или callback-плагины.

#### Пример структуры роли:
```
my_role/
├── tasks/
│   └── main.yml
├── handlers/
│   └── main.yml
├── templates/
│   └── nginx.conf.j2
├── files/
│   └── myfile
├── vars/
│   └── main.yml
├── defaults/
│   └── main.yml
├── meta/
│   └── main.yml
├── tests/
│   └── test.yml
├── README.md
```
### Роли на примере развертывания Kubernetes

Вот пример простой роли Ansible для развертывания Kubernetes на нескольких серверах. Этот пример покажет, как установить `kubeadm`, `kubelet`, и `kubectl`, а также как инициализировать мастер-узел и присоединить воркеры.

#### Структура роли:

```
roles/
└── kubernetes/
    ├── tasks/
    │   ├── install.yml
    │   └── main.yml
    ├── handlers/
    │   └── main.yml
    ├── templates/
    ├── files/
    ├── vars/
    │   └── main.yml
    ├── defaults/
    │   └── main.yml
    ├── meta/
    │   └── main.yml
```

#### 1. `tasks/main.yml` — Основной файл с задачами

Этот файл связывает все задачи из других файлов.

```yaml
---
- name: Install Kubernetes packages
  include_tasks: install.yml

- name: Initialize Kubernetes master node
  when: ansible_hostname == inventory_hostname and kubernetes_role == "master"
  include_tasks: init_master.yml

- name: Join worker nodes to cluster
  when: kubernetes_role == "worker"
  include_tasks: join_worker.yml
```

#### 2. `tasks/install.yml` — Установка Kubernetes

Задачи для установки необходимых пакетов Kubernetes на всех хостах (мастер и воркеры).

```yaml
---
- name: Install Docker
  apt:
    name: docker.io
    state: present
    update_cache: yes

- name: Add Kubernetes APT key
  apt_key:
    url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
    state: present

- name: Add Kubernetes APT repository
  apt_repository:
    repo: "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    state: present

- name: Install Kubernetes components
  apt:
    name:
      - kubelet
      - kubeadm
      - kubectl
    state: latest
    update_cache: yes

- name: Hold Kubernetes packages
  apt:
    name: "{{ item }}"
    state: present
    package_type: hold
  loop:
    - kubelet
    - kubeadm
    - kubectl

- name: Enable and start Docker
  service:
    name: docker
    enabled: yes
    state: started
```

#### 3. `tasks/init_master.yml` — Инициализация мастер-узла

Этот файл выполняет инициализацию мастер-узла Kubernetes.

```yaml
---
- name: Initialize Kubernetes master
  command: kubeadm init --pod-network-cidr={{ pod_network_cidr }} --apiserver-advertise-address={{ ansible_default_ipv4.address }}
  register: kubeadm_init

- name: Create Kubernetes config directory for the admin user
  file:
    path: /home/{{ admin_user }}/.kube
    state: directory
    owner: "{{ admin_user }}"
    group: "{{ admin_user }}"
    mode: '0755'

- name: Copy kubeconfig to user home
  command: "cp -i /etc/kubernetes/admin.conf /home/{{ admin_user }}/.kube/config"
  become: yes
  become_user: "{{ admin_user }}"

- name: Set ownership for kubeconfig
  file:
    path: /home/{{ admin_user }}/.kube/config
    owner: "{{ admin_user }}"
    group: "{{ admin_user }}"
    mode: '0644'

- name: Install Calico network plugin
  command: kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

#### 4. `tasks/join_worker.yml` — Присоединение воркер-узлов к кластеру

Этот файл выполняет присоединение воркеров к уже существующему кластеру.

```yaml
---
- name: Join the Kubernetes cluster
  command: "{{ kubeadm_join_command }}"
```

#### 5. `handlers/main.yml` — Хэндлеры для перезапуска сервисов

Этот файл содержит хэндлеры, которые могут быть вызваны для перезапуска служб при изменениях.

```yaml
---
- name: Restart kubelet
  service:
    name: kubelet
    state: restarted
```

#### 6. `vars/main.yml` — Переменные

Здесь хранятся переменные, которые могут быть изменены в зависимости от среды.

```yaml
---
pod_network_cidr: "192.168.0.0/16"
admin_user: "ubuntu"
```

#### 7. `defaults/main.yml` — Переменные по умолчанию

Эти переменные могут быть переопределены в playbook'е.

```yaml
---
kubernetes_role: "worker"
kubeadm_join_command: ""
```

### 8. `meta/main.yml` — Метаданные роли

Здесь можно описать зависимости от других ролей.

```yaml
---
dependencies: []
```

#### Playbook для вызова роли

Вот пример playbook'а, который разворачивает Kubernetes, используя эту роль.

```yaml
---
- hosts: all
  become: yes
  roles:
    - kubernetes

  vars:
    kubernetes_role: "{{ group_names[0] }}"
    kubeadm_join_command: "kubeadm join 192.168.1.100:6443 --token abcdef.0123456789abcdef --discovery-token-ca-cert-hash sha256:..."
```

#### Инвентарь

Пример инвентаря, где указаны мастер и воркер-узлы.

```
[master]
master-node

[worker]
worker-node-1
worker-node-2
```

#### Пояснение к ролям:

1. **Мастер-узел** выполняет инициализацию кластера с помощью `kubeadm init` и устанавливает плагин сети.
2. **Воркеры** присоединяются к кластеру, используя команду `kubeadm join`, которая должна быть сгенерирована на мастер-узле после инициализации и передана в playbook для воркеров.
3. **Хэндлеры** используются для перезапуска сервиса `kubelet` при необходимости (например, после изменения конфигурации).
4. **Файлы и шаблоны** могут быть добавлены в зависимости от потребностей, например, для кастомизации конфигураций Kubernetes или плагинов.

Это пример базовой роли для установки Kubernetes. В зависимости от конкретных требований можно расширять её, добавлять мониторинг (Prometheus), хранение логов (Fluentd), балансировщики и т.д.


# ПРАКТИКА

проверка синтаксиса
ansible-playbook --syntax-check playbook.yml


## Конфиг файлы

### ansible.cfg

 [defaults]  
 host_key_checking = false  
 inventory         = ./hosts.txt  
 ansible_become_pass = 123  # указываем пароль от sudo

### inventory

[staging_DB]
172.18.0.2     

[staging_WEB]
172.18.0.3    

[staging_APP]
172.18.0.4   


[all:vars]
ansible_user=user
ansible_ssh_private_key=/home/alex/.ssh/id_rsa

### ansible.cfg

 [defaults]  
 host_key_checking = false  # отключаем подверждение подключения
 inventory         = ./hosts.txt  
 ansible_become_pass = 123  # указываем пароль от sudo


## Ad-hoc команды  

ansible all -m shell -a "ls /etc"  
-m ключ, что указываем это модуль  
-a ключ, что указываем аргумент  
  

проверка сможет ли сервер подконнектиться к этому url адресу. только заголовки:  
ansible all -m uri -a "url=https://ya.ru"  
вместе с телом сайта:  
ansible all -m uri -a "url=https://ya.ru return_content=yes "

### установка пакетов
ansible all -m apt -a "name=httpd state=present" -b
+ present значит что пакет должен быть установлен, если его нет, а absent — для удаления пакета.

даем команду чтобы сервис httpd запускался при старте
ansible all -m service -a "name=httpd state=started enabled=yes" -b

### Копирование фала на все сервера  
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

#### Основные атрибуты модуля `file`

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

#### Примеры использования модуля `file`

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



# Примеры плейбуков практики

Установка nginx и копирование сайта
```yaml
---
- name: install nginx and upload web page
  hosts: all
  become: yes

  vars:
    source_file: ./mysite/index.html
    destin_file: /var/www/html

  tasks:
  - name: Install nginx
    apt:
      name: nginx
      state: latest

  - name: Copy MySite
    copy: src={{source_file}} dest={{destin_file}} mode=0644
    notify: RestartNginx # если произошли изменения в копируемых файлах, то ансибл копирует их и вызывает хэндлер, который рестартует nginx

  - name: Start Nginx and enabled on boot
    service:
      name: nginx
      state: started
      enabled: yes

  handlers: # вызываемый хэндлер для рестарта сервиса nginx
  - name: RestartNginx
    service:
      name: nginx
      state: restarted
```

переменные, переменные hosts
```conf
[PROD_SERVERS_WEB]
linux1  ansible_host=172.18.0.2     owner=Alex
linux2  ansible_host=172.18.0.4     owner=Alexx
linux3  ansible_host=172.18.0.3     owner=Alexxx
```

## Playbook

```yaml

---
- name: VARS playbook
  hosts: all
  become: yes

  vars:
    message1: Privet
    message2: Hi Hi
    secret: SDDLKJHFGKLJSHDFLGKJHFDLKJSHDFKJHGS

  tasks:

  - name: Print Secret var
    debug:
      var: secret

  - debug:
      msg: "Sekretnoe Slovo: {{ secret }}"

  - debug:
      msg: "Vladelec  -->{{ owner }}<--" #вывод переменной из hosts

  - set_fact: new_var_message="{{ message1 }} {{ message2 }} from {{ owner }}"

  - debug:
      var: new_var_message 

  - debug:
      var: ansible_distribution # вывод переменных из команды ansible all -m setup 

# вывод инфы о выполненной команде в shell
  - shell: uptime
    register: result # получили ответ в формате json

  - debug:
      var: result.stdout # вывели
```

### Shell

Варианты использования в плейбуках

```yaml
- name: get permission for "{{ ansible_user }}"  # Предоставляем доступ обычному пользователю к конфигурации кластера.
  shell: "{{ item }}"
  with_items:
   - mkdir -p $HOME/.kjjjube                 #Создаем каталог .kube в домашнем каталоге пользователя, если он не существует.
   - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config # Копируем файл конфигурации администратора в каталог .kube пользователя.
   - sudo chown $(id -u):$(id -g) $HOME/.kube/config #Изменяем владельца файла конфигурации на текущего пользователя.
  

- name: Network init - Install calico       # установка сетевого решения Calico для подов Kubernetes.
  shell: "{{ item }}"
  with_items:
   - curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml -O
   - kubectl apply -f calico.yaml
```

## Роли


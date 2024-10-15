Чтобы настроить VPN сервер на Ubuntu и автоматизировать подключение к нему в Proxmox (PVE), нужно выполнить несколько шагов:

### 1. Установка и настройка VPN-сервера на Ubuntu
Рассмотрим настройку VPN сервера с использованием **WireGuard** — это современный VPN с простым конфигурированием и высокой производительностью.

#### Шаг 1: Установка WireGuard
На вашем Ubuntu сервере выполните команду для установки WireGuard:

```bash
sudo apt update
sudo apt install wireguard
```

#### Шаг 2: Генерация ключей
WireGuard использует пару ключей для шифрования. Сгенерируйте их:

```bash
wg genkey | tee privatekey | wg pubkey > publickey
```

Команда создаст два файла: `privatekey` и `publickey`.

#### Шаг 3: Настройка конфигурации сервера
Создайте конфигурационный файл для WireGuard:

```bash
sudo nano /etc/wireguard/wg0.conf
```

Добавьте следующее содержимое (замените `PrivateKey` на сгенерированный ключ):

```ini
[Interface]
PrivateKey = ВАШ_СЕКРЕТНЫЙ_КЛЮЧ
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = ПУБЛИЧНЫЙ_КЛЮЧ_КЛИЕНТА
AllowedIPs = 10.0.0.2/32
```

Замените `PublicKey` на публичный ключ клиента, который подключается к серверу.

#### Шаг 4: Включение маршрутизации (опционально)
Если вам нужно, чтобы VPN сервер маршрутизировал трафик, включите маршрутизацию:

```bash
sudo nano /etc/sysctl.conf
```

Найдите строку:

```bash
#net.ipv4.ip_forward=1
```

И раскомментируйте её, убрав `#`:

```bash
net.ipv4.ip_forward=1
```

Затем примените изменения:

```bash
sudo sysctl -p
```

#### Шаг 5: Запуск WireGuard
Запустите WireGuard:

```bash
sudo systemctl start quick@wg0.service
sudo systemctl enable quick@wg0.service
```

Теперь VPN сервер настроен и работает.

### 2. Автоматическое подключение Proxmox к VPN

Теперь вам нужно настроить Proxmox на автоматическое подключение к вашему VPN серверу.

#### Шаг 1: Установка WireGuard на Proxmox
На Proxmox выполните следующие команды:

```bash
apt update
apt install wireguard
```

#### Шаг 2: Настройка WireGuard клиента
На Proxmox создайте конфигурацию для клиента:

```bash
nano /etc/wireguard/wg0.conf
```

Добавьте следующую конфигурацию (замените `PrivateKey` на сгенерированный для клиента, а `PublicKey` на публичный ключ вашего VPN сервера):

```ini
[Interface]
PrivateKey = ВАШ_СЕКРЕТНЫЙ_КЛЮЧ
Address = 10.0.0.2/24

[Peer]
PublicKey = ПУБЛИЧНЫЙ_КЛЮЧ_СЕРВЕРА
Endpoint = ВАШ_IP_АДРЕС:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

#### Шаг 3: Запуск и автоматизация WireGuard на Proxmox
Запустите WireGuard:

```bash
wg-quick up wg0
```

Чтобы автоматизировать запуск WireGuard при старте системы:

```bash
systemctl enable quick@wg0.service
```

Теперь при перезагрузке Proxmox автоматически будет подключаться к вашему VPN серверу.

### 3. Проверка соединения
Для проверки состояния VPN соединения выполните на Proxmox команду:

```bash
wg show
```

Вы должны увидеть активное VPN соединение с сервером.

### Дополнительно
- Убедитесь, что порты WireGuard (по умолчанию 51820) открыты на вашем Ubuntu сервере.
- Если у вас настроен брандмауэр, убедитесь, что разрешены нужные порты и правила маршрутизации.

убеждаемся что на роутере проброшен порт 51820 по udp

# ВАЖНО
systemctl restart wg-quick@wg0.service перезапуск службы при изменении конфигурации
sudo nano /etc/wireguard/wg0.conf конфигурация **sudo ЕСЛИ ЕСТЬ В СИСТЕМЕ, ТО НУЖНО ОТ НЕГО СОЗДАВАТЬ И РЕДАКТИРОВАТЬ КОНФИГУРАЦИИ**

на клиенте 
wg-quick up wg0  запуск соединения с сервером 
wg-quick down wg0  закрытие соединения с сервером 

пример удачного соединения на сервере
root@anderson:~# wg show
interface: wg0
  public key: b8XxIX/wuzviRkpQg8imi8uRFm07D9WZRcZBP3mQcQ0=
  private key: (hidden)
  listening port: 52845
  fwmark: 0xca6c

peer: KRIr4mULgaY+50LLGJ5zJprG6yHPrklKqb41w9FWTh0=
  endpoint: 37.220.153.156:51820
  allowed ips: 0.0.0.0/0
  latest handshake: 9 seconds ago
  transfer: 915.54 KiB received, 4.32 MiB sent
  persistent keepalive: every 25 seconds
root@anderson:~# 

пример удачного соединения на клиенте
root@anderson:~# wg show
interface: wg0
  public key: b8XxIX/wuzviRkpQg8imi8m07D9WZRcZBP3mQcQ0=
  private key: (hidden)
  listening port: 52845
  fwmark: 0xca6c

peer: KRIr4mULgaY+50LLGJ5zJprG6yHPrkb41w9FWTh0=
  endpoint: 37.220.153.156:51820
  allowed ips: 0.0.0.0/0
  latest handshake: 1 minute, 34 seconds ago
  transfer: 1022.29 KiB received, 4.45 MiB sent
  persistent keepalive: every 25 seconds
root@anderson:~# 

Конфигурация текущая на клиенте
[Interface]
PrivateKey = mMZzdFI/NEsuT5Z6VSTbpsVVSAkvY1Bz1CGA=
Address = 10.0.0.2/24

[Peer]
PublicKey = KRIr4mULgaY+50LLGJ5zJprG6yHPrqb41w9F=
Endpoint = da720d2a981e.sn.mynetname.net:51820
AllowedIPs = 10.0.0.1/32
PersistentKeepalive = 25

конфигурация текущая на сервере

# решение проблемы с маршрутизацией трафика

root@anderson:~# ip route get 8.8.8.8
8.8.8.8 dev wg0 table 51820 src 10.0.0.2 uid 0 
    cache 

Результат команды `ip route get 8.8.8.8` показывает, что запрос к IP-адресу `8.8.8.8` пытается пройти через интерфейс `wg0`, что указывает на то, что маршрутизация не настроена должным образом. Это объясняет, почему вы получаете 100% потерь при попытке пинга к интернету.

### Проблема

Ваши текущие настройки `AllowedIPs` на Proxmox, скорее всего, неправильно настроены, что приводит к тому, что весь трафик пытается проходить через туннель WireGuard. 

### Решение

Чтобы исправить это, вам нужно изменить конфигурацию WireGuard на Proxmox и убедиться, что в параметре `AllowedIPs` не прописаны адреса, которые не относятся к сети WireGuard или к интернету.

#### Шаги для решения:

1. **Измените конфигурацию WireGuard на Proxmox:**

   Откройте конфигурационный файл WireGuard на Proxmox, который, скорее всего, находится по адресу `/etc/wireguard/wg0.conf`, и убедитесь, что в секции `[Peer]` для Ubuntu указаны правильные `AllowedIPs`. Например:

   ```ini
   [Peer]
   PublicKey = <PUBLIC_KEY_UBUNTU>
   Endpoint = <UBUNTU_SERVER_IP>:51820
   AllowedIPs = 10.0.0.1/32
   ```

   В данном случае `10.0.0.1/32` указывает на IP-адрес Ubuntu в сети WireGuard. Убедитесь, что **не** указаны маршруты типа `0.0.0.0/0` или `10.0.0.0/24`.

2. **Перезапустите интерфейс WireGuard:**

   После изменения конфигурации перезапустите WireGuard на Proxmox:

   ```bash
   wg-quick down wg0
   wg-quick up wg0
   ```

3. **Проверьте маршруты еще раз:**

   После перезапуска выполните команду `ip route get 8.8.8.8` снова, чтобы проверить, через какой интерфейс идет трафик. 

   Вы должны увидеть, что запрос теперь идет через основной шлюз (`vmbr0` или `eno1`), а не через `wg0`. 

### Пример корректного результата:

После корректировки вы должны получить что-то вроде:

```bash
8.8.8.8 dev vmbr0 table 51820 src 192.168.88.217 uid 0
```

Это будет означать, что интернет-трафик идет через основной интерфейс, а трафик для сети WireGuard будет продолжать идти через `wg0`.

скриптик для реконнекта
#!/bin/bash
wg-quick down wg0
wg-quick up wg0

Теперь трафик идет правильно:

root@anderson:~# ip route get 8.8.8.8
8.8.8.8 via 192.168.88.1 dev vmbr0 src 192.168.88.217 uid 0 
    cache 

# автоподключение
```bash
crontab -e
@reboot wg-quick up wg0
* * * * * wg-quick up wg0 > /dev/null 2>&1
# > /dev/null 2>&1  отключение уведомлений на почту для конкретной задачи
```
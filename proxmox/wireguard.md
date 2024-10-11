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
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25

конфигурация текущая на сервере
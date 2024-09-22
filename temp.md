Чтобы скачать сайт и базу данных с удалённого хостинга через SSH, выполните следующие шаги:

### 1. **Скачивание файлов сайта**

Сначала подключитесь к удалённому серверу через SSH:

```bash
ssh username@hostname
```

Затем найдите директорию, где расположены файлы сайта. Обычно это папка вроде `public_html`, `www` или что-то похожее.

заархивировать
tar -czvf site_backup.tar.gz public_html
+ -c — создание архива.
+ -z — сжатие архива с помощью gzip.
+ -v — вывод информации о процессе архивирования.
+ -f — имя создаваемого файла.
+ . — указывает, что нужно архивировать все файлы из текущей директории.


Чтобы скачать эти файлы на локальную машину, используйте команду `scp`:

```bash
scp -P 8228 -r sambiaho@sambiahotel.com:/home/sambiaho/public_html /home/alex/D
```

- `username@hostname` — имя пользователя и адрес хоста.
- `/path/to/remote/site` — путь к файлам сайта на удалённом сервере.
- `/path/to/local/directory` — путь на вашей локальной машине, куда будут скопированы файлы.

### 2. **Экспорт базы данных MySQL**

Подключитесь к удалённому серверу через SSH, если вы ещё не сделали этого:

```bash
ssh username@hostname
```

Сделайте дамп базы данных с помощью `mysqldump`:

```bash
mysqldump -u db_username -p db_name > backup.sql
```

- `db_username` — имя пользователя базы данных.
- `db_name` — имя базы данных.
- `backup.sql` — файл, в который будет сохранена база данных.

Дамп можно скачать на локальную машину с помощью той же команды `scp`:

```bash
scp username@hostname:/path/to/backup.sql /path/to/local/directory
```

### 3. **Дополнительные советы**
- Если база данных большая, можно использовать сжатие:

```bash
mysqldump -u db_username -p db_name | gzip > backup.sql.gz
```

И затем скачать сжатый файл:

```bash
scp username@hostname:/path/to/backup.sql.gz /path/to/local/directory
```

### Импорт базы данных
```bash
mysql -u root -p my_database < /path/to/backup.sql
```

Переместить все файлы и папки, включая скрытые на один уровень вверх
mv {.,}* ..


#laravel
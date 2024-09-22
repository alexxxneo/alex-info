#!/bin/bash
set -euo pipefail

### Настройки

# Имя бакета, куда будут заливаться бекапы
S3_BUCKET='alex_icebox'

# Endpoint URL (в примере: Hotbox, горячие данные)
S3_ENDPOINT='https://ib.bizmrg.com'

# Путь к директории, которую необходимо бекапить
BACKUP_DIR='/home/alex/D/YANDEXDISK/1DEVOPS/alex-info/s3/backup_dir'

# Путь к директории где будут создаваться архивы.
# Эта папка будет синхронизироваться с S3,
# поэтому при удалении там файлов - они пропадут и в хранилище.
# Путь должен быть БЕЗ слеша на конце!
SYNC_DIR='/home/alex/D/YANDEXDISK/1DEVOPS/alex-info/s3/s3_backup_sync'

# Префикс создаваемых архивов
ARCHIVE_PREFIX='data'

### Основной код

# Время создания бэкапа
DATE="$(date +%Y-%m-%d_%H-%M)"

# Создаем директорию для синхронизации, если она ещё не существует
mkdir -p "${SYNC_DIR}"

# Удаляем все архивы из директории для синхронизции, дата изменения которых больше 7 дней
find "${SYNC_DIR}/${ARCHIVE_PREFIX}*" -mtime +7 -exec rm {} \;

# Создаем архив из директориии для бекапа в папке для синхронизации
tar -czf "${SYNC_DIR}/${ARCHIVE_PREFIX}_${DATE}.tar.gz" "${BACKUP_DIR}"

# Синхронизируем папку с S3 хранилищем.
# Стоит обратить внимание на аргумент `--delete` – он означает,
# что если в исходной директории (SYNC_DIR) нет файла, который есть в S3,
# то он удалится в хранилище.
/usr/local/bin/aws s3 sync --delete "${SYNC_DIR}" "s3://${S3_BUCKET}" --endpoint-url="${S3_ENDPOINT}"
#!/bin/bash

# Проверка, что передан аргумент с количеством CPU-устройств
if [ -z "$1" ]; then
  echo "Использование: $0 <количество CPU-устройств>"
  exit 1
fi

# Количество CPU-устройств
CPU_DEVICES=$1

# Путь к файлу службы
SERVICE_FILE="/etc/systemd/system/initverse-miner.service"

# Временный файл для хранения изменений
TEMP_FILE=$(mktemp)

# Чтение файла службы и изменение строки ExecStart
while IFS= read -r line; do
  if [[ $line == ExecStart=* ]]; then
    # Извлечение адреса и пула
    POOL=$(echo "$line" | awk '{print $2}')
    # Формирование новой строки ExecStart
    NEW_EXECSTART="ExecStart=/root/initverse/iniminer-linux-x64 --pool $POOL"
    for ((i=1; i<=CPU_DEVICES; i++)); do
      NEW_EXECSTART+=" --cpu-devices $i"
    done
    echo "$NEW_EXECSTART"
  else
    echo "$line"
  fi
done < "$SERVICE_FILE" > "$TEMP_FILE"

# Перемещение временного файла в оригинальный
mv "$TEMP_FILE" "$SERVICE_FILE"

# Перезагрузка systemd для применения изменений
systemctl daemon-reload

# Перезапуск службы
systemctl restart initverse-miner.service

echo "Файл службы обновлен и служба перезапущена с $CPU_DEVICES CPU-устройствами."

journalctl -u initverse-miner -n 25 -f --no-hostname

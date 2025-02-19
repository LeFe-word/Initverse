#!/bin/bash

SERVICE_FILE="/etc/systemd/system/initverse-miner.service"
TEMP_FILE="/tmp/initverse-miner.service.tmp"

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <cpu-device-1> <cpu-device-2> ... <cpu-device-N>"
    exit 1
fi

# Формируем строку новых аргументов
CPU_DEVICES=""
for dev in "$@"; do
    CPU_DEVICES+=" --cpu-devices $dev"
done

# Обновляем строку ExecStart: удаляем все вхождения '--cpu-devices <число>'
awk -v devices="$CPU_DEVICES" '
  /^ExecStart=/ {
    # Удаляем все аргументы --cpu-devices <число>
    gsub(/ --cpu-devices [0-9]+/, "");
    # Добавляем новые аргументы в конец строки
    $0 = $0 devices;
  }
  { print }
' "$SERVICE_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"

# Перезагружаем конфигурацию systemd и перезапускаем службу
systemctl daemon-reload
systemctl restart initverse-miner

echo "Обновлены CPU-устройства: $CPU_DEVICES"
journalctl -u initverse-miner -n 25 -f --no-hostname

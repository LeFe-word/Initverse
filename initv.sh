#!/bin/bash

SERVICE_FILE="/etc/systemd/system/initverse-miner.service"
TEMP_FILE="/tmp/initverse-miner.service.tmp"

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <cpu-device-1> <cpu-device-2> ... <cpu-device-N>"
    exit 1
fi

# Создаём строку с аргументами --cpu-devices
CPU_DEVICES=""
for dev in "$@"; do
    CPU_DEVICES+=" --cpu-devices $dev"
done

# Обновляем файл службы
awk -v devices="$CPU_DEVICES" \
    '/^ExecStart=/ { sub(/ --cpu-devices [0-9]+( --cpu-devices [0-9]+)*/, devices) } 1' \
    "$SERVICE_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"

# Перезагружаем службу
systemctl daemon-reload
systemctl restart initverse-miner

echo "Updated CPU devices: $CPU_DEVICES"


journalctl -u initverse-miner -n 25 -f --no-hostname

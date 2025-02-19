#!/bin/bash

# Путь к файлу службы
SERVICE_FILE="/etc/systemd/system/initverse-miner.service"

# Запрашиваем у пользователя количество CPU-устройств
read -p "Введите количество CPU-устройств: " CPU_COUNT

# Проверяем, что введено число
if ! [[ "$CPU_COUNT" =~ ^[0-9]+$ ]]; then
  echo "Ошибка: введите корректное число."
  exit 1
fi

# Формируем новую строку с --cpu-devices
NEW_CPU_DEVICES=""
for ((i=1; i<=CPU_COUNT; i++)); do
  NEW_CPU_DEVICES+=" --cpu-devices $i"
done

# Используем sed для замены только части с --cpu-devices
sudo sed -i -E "s|(ExecStart=/root/initverse/iniminer-linux-x64 --pool stratum\+tcp://[^ ]+)|\\1$NEW_CPU_DEVICES|" "$SERVICE_FILE"

# Перезагружаем systemd, чтобы применить изменения
sudo systemctl daemon-reload

# Перезапускаем службу
sudo systemctl restart initverse-miner

echo "Количество --cpu-devices изменено на: $NEW_CPU_DEVICES"
journalctl -u initverse-miner -n 25 -f --no-hostname

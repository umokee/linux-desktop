#!/bin/bash

graceful_shutdown() {
  echo "Завершение программ..."
  
  # Уведомление пользователя (если используется графическая среда)
  if [ -n "$DISPLAY" ]; then
    notify-send "Завершение работы" "Компьютер будет выключен через 5 секунд."
  fi
  
  # Мягкое завершение процессов
  killall -15
  sleep 5
  
  # Принудительное завершение оставшихся процессов
  echo "Принудительное завершение оставшихся процессов..."
  killall -9
  
  echo "Все программы завершены."
}

options=" Shutdown\n Reboot"
chosen=$(echo -e "$options" | rofi -dmenu)

case "$chosen" in
  " Shutdown")
    graceful_shutdown
    echo "Выключение компьютера..."
    shutdown -h now
    ;;
  " Reboot")
    graceful_shutdown
    echo "Перезагрузка компьютера..."
    reboot
    ;;
  *)
    echo "Отменено"
    ;;
esac

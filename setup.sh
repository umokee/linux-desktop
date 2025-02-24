#!/bin/bash

CONFIG_REPO="https://github.com/umokee/linux-desktop"
TEMP_DIR="/tmp/bspwm-setup"
CONFIG_DIR="$HOME/.config"

log() {
    echo -e "[+] $1"
}

error_exit() {
    echo "Ошибка: $1"
    exit 1
}

install_packages() {
    update_system() {
        echo "Обновление системы..."
        sudo pacman -Syu --neconfirm
    }

    install_programs() {
        echo "Установка приложений..."
        sudo pacman -S --neconfirm alacritty polybar plank rofi thunar ranger dunst picom redshift firefox flameshot telegram-desktop lxappearance
    }
    
    install_utilities() {
        echo "Установка утилит..."
        sudo pacman -S --neconfirm git base-devel github-cli speech-dispatcher pipewire pipewire-pulse wireplumber ttf-jetbrains-mono-nerd fuse xdotool
    }

    install_yay() {
        echo "Установка yay..."
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
    }

    log "Обновление системы и установка пакетов..."
    update_system
    install_programs
    install_utilities
    install_yay
}

install_configs_themes() {
    clone_configs() {
        echo "Клонирование репозитория..."
        git clone "$CONFIG_REPO" "$TEMP_DIR"
    }

    copy_configs() {
        echo "Копирование конфигов..."
        cp -r "$TEMP_DIR/configs/bin" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/alacritty" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/bspwm" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/sxhkd" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/polybar" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/rofi" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/dunst" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/picom" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/redshift" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/wallpapers" "$CONFIG_DIR"
        cp -r "$TEMP_DIR/configs/gtk-3.0" "$CONFIG_DIR"
    }

    copy_themes() {
        echo "Копирование тем..."
        cp -r "$TEMP_DIR/themes/system/.themes" "$HOME"
        cp -r "$TEMP_DIR/themes/system/.icons" "$HOME"
        cp -r "$TEMP_DIR/themes/plank/themes" "$HOME/.local/share/plank/themes"
        cp -r "$TEMP_DIR/themes/.gtkrc-2.0" "$HOME"
    }

    install_fifefox_theme() {
        echo "Установка темы для firefox..."
        destination_dir=$(find $HOME/.mozilla/firefox -type d -name "*default-release*" -print -quit)
        cp -r "$TEMP_DIR/firefox/chrome" "$destination_dir/"
    }

    cleanup() {
        echo "Очистка временных файлов..."
        rm -rf "$TEMP_DIR"
    }

    log "Установка конфигов и тем..."
    clone_configs
    copy_configs
    copy_themes
    install_fifefox_theme
    cleanup
}

set_settings() {
    log "Применение настроек..."
    xdg-settings set default-web-browser firefox.desktop
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme 'macOS Dark'
}

mount_disks() {
    create_mount_points() {
        echo "Создание точек монтирования..."
        sudo mkdir /mnt/disk1/ /mnt/disk2/
        sudo chown -R $USER:$USER /mnt/disk1 /mnt/disk2
    }

    format_disk() {
        local DEVICE=$1
        local UUID=$2

        echo "Форматирование $DEVICE..."
        sudo mkfs.btrfs -f "$DEVICE" || error_exit "не удалось отформатировать диск $DEVICE"
    }

    add_to_fstab() {
        local UUID=$1
        local MOUNT_POINT=$2

        echo "Добавление записи для $UUID в /etc/fstab..."
        echo "UUID=$UUID $MOUNT_POINT btrfs defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
    }

    get_uuid() {
        local DEVICE=$1
        local UUID=$(sudo blkid -s UUID -o value "$DEVICE")

        if [ -z "$UUID" ]; then
            error_exit "Не удалось найти UUID для устройства $DEVICE."
        fi

        echo "$UUID"
    }

    create_mount_points

    read -p "Введите устройство для первого диска: " DEVICE1
    UUID1=$(get_uuid "$DEVICE1")
    echo "Найден UUID для $DEVICE1: $UUID1"

    read -p "Введите устройство для второго диска: " DEVICE2
    UUID2=$(get_uuid "$DEVICE2")
    echo "Найден UUID для $DEVICE2: $UUID2"

    format_disk "$DEVICE1" "$UUID1"
    format_disk "$DEVICE2" "$UUID2"

    add_to_fstab "$UUID1" "/mnt/disk1"
    add_to_fstab "$UUID2" "/mnt/disk2"

    log "Все диски успешно отформатированы и добавлены в /etc/fstab."
}

main() {
    install_packages
    install_configs_themes
    set_settings
    mount_disks
    log "Установка завершена. Перезагрузи устройство."
}

main
#!/bin/bash

BUILDER_DIR="$HOME/projects/linux-desktop"
CONFIG_DIR="$HOME/.config"

log() {
    echo -e "/n[+] $1"
}

update_configs() {
    log "Обновление конфигов..."
    cp -r "$CONFIG_DIR/bin" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/alacritty" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/bspwm" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/sxhkd" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/polybar" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/rofi" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/dunst" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/picom" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/redshift" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/wallpapers" "$BUILDER_DIR/configs"
    cp -r "$CONFIG_DIR/gtk-3.0" "$BUILDER_DIR/configs"
}

update_themes() {
    log "Обновление тем..."
    cp -r "$HOME/.themes" "$BUILDER_DIR/themes/system"
    cp -r "$HOME/.icons" "$BUILDER_DIR/themes/system"
    cp -r "$HOME/.local/share/plank/themes" "$BUILDER_DIR/themes/plank"
    cp -r "$HOME/.gtkrc-2.0" "$BUILDER_DIR/themes/"
}

main() {
    update_configs
    update_themes
    log "Обновление завершено."
}

main
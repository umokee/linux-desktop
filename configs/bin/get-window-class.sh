#!/bin/bash

WINDOW_ID=$(xdotool getactivewindow)

if [ -z "$WINDOW_ID" ]; then
    notify-send "Window Class" "No active window found."
    exit 1
fi

CLASS_NAME=$(xprop -id $WINDOW_ID WM_CLASS | grep -oP '"\K[^,"]+')

notify-send "$CLASS_NAME"
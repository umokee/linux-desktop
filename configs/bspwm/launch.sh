#!/bin/bash

restart_process() {
    local process_name=$1
    shift
    if pgrep -x "$process_name" > /dev/null; then
        pkill -x "$process_name"
    fi
    "$@" &
}

restart_process sxhkd sxhkd

restart_process dunst dunst

restart_process picom picom --config ~/.config/picom/picom.conf

restart_process plank plank

~/.config/polybar/launch.sh

setxkbmap 'us,ru' -option 'grp:lctrl_lshift_toggle' &

feh --no-fehbg --bg-fill --monitor 0 ~/.config/wallpapers/minimal-saturn-planet.jpg \
    --no-fehbg --bg-fill --monitor 1 ~/.config/wallpapers/dot-circle.jpg &

pgrep -x redshift > /dev/null || redshift &
pgrep -x firefox > /dev/null || firefox &
pgrep -x telegram-desktop > /dev/null || telegram-desktop &

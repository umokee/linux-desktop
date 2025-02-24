#!/bin/sh

pgrep -x polybar
status=$?

if test $status -eq 0
then
  killall polybar
  bspc config -m DP-0 top_padding 0
  bspc config -m HDMI-0 top_padding 0
else
  $HOME/.config/polybar/launch.sh
  bspc config -m DP-0 top_padding 31
  bspc config -m HDMI-0 top_padding 0
fi

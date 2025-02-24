#!/bin/sh

MIC_ID="@DEFAULT_SOURCE@"

MUTED=$(wpctl get-volume $MIC_ID | grep -o "MUTED")

if [ "$MUTED" = "MUTED" ]; then
  echo "󰍭 Mtd "
else
  echo "󰍬 Wrk "
fi
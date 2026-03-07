#!/bin/bash

DEVICE_NAME="ELAN0746:00 04F3:318B Touchpad"

ID=$(xinput list --id-only "$DEVICE_NAME")

STATE=$(xinput list-props "$ID" | awk '/Device Enabled/ {print $4}')

if [ "$STATE" -eq 1 ]; then
    xinput disable "$ID"
    notify-send "Touchpad disabled"
else
    xinput enable "$ID"
    notify-send "Touchpad enabled"
fi

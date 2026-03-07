#!/bin/bash

DEVICE_NAME="ELAN2513:00 04F3:2D9D"

ID=$(xinput list --id-only "$DEVICE_NAME")

STATE=$(xinput list-props "$ID" | awk '/Device Enabled/ {print $4}')

if [ "$STATE" -eq 1 ]; then
    xinput disable "$ID"
    notify-send "Touchscreen disabled"
    xfconf-query --channel thunar --property /misc-single-click --set false
    killall touchegg
else
    xinput enable "$ID"
    notify-send "Touchscreen enabled"
    xfconf-query --channel thunar --property /misc-single-click --set true
    touchegg
fi

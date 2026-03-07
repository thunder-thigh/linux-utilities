#!/bin/bash

#sleep 3

# -------- Identify real user (not root) --------
REAL_USER=$(logname)
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
USER_UID=$(id -u "$REAL_USER")

STATE_FILE="$HOME/.cache/ryzenadj"
ICON="battery"
RYZENADJ="/usr/local/bin/ryzenadj"

# Ensure cache directory exists
mkdir -p "$(dirname "$STATE_FILE")"

# If state file missing, create it with 'balanced'
[ -f "$STATE_FILE" ] || echo "balanced" > "$STATE_FILE"

CURRENT=$(cat "$STATE_FILE")

# ------------------------------
# Power profiles
# ------------------------------
apply_battery() {
  $RYZENADJ \
    --stapm-limit=8000 \
    --fast-limit=10000 \
    --slow-limit=8000 \
    --apu-slow-limit=8000 \
    --stapm-time=600 \
    --slow-time=2000 \
    --tctl-temp=75 \
    --vrm-current=18000 \
    --vrmmax-current=40000 \
    --vrmsoc-current=8000 \
    --vrmsocmax-current=12000
}

apply_balanced() {
  $RYZENADJ \
    --stapm-limit=15000 \
    --fast-limit=18000 \
    --slow-limit=15000 \
    --apu-slow-limit=15000 \
    --stapm-time=300 \
    --slow-time=1000 \
    --tctl-temp=80 \
    --vrm-current=25000 \
    --vrmmax-current=60000 \
    --vrmsoc-current=10000 \
    --vrmsocmax-current=15000
}

apply_performance() {
  $RYZENADJ \
    --stapm-limit=20000 \
    --fast-limit=25000 \
    --slow-limit=20000 \
    --apu-slow-limit=20000 \
    --stapm-time=200 \
    --slow-time=600 \
    --tctl-temp=90 \
    --vrm-current=30000 \
    --vrmmax-current=80000
}

apply_default() {
  $RYZENADJ \
    --stapm-limit=30000 \
    --fast-limit=30000 \
    --slow-limit=30000 \
    --apu-slow-limit=30000 \
    --stapm-time=100 \
    --slow-time=300 \
    --tctl-temp=95 \
    --vrm-current=40000 \
    --vrmmax-current=90000 \
    --vrmsoc-current=15000 \
    --vrmsocmax-current=25000
}

# ------------------------------
# State machine
# ------------------------------
case "$CURRENT" in
  battery)
    apply_balanced
    MESSAGE="Balanced (15W sustained)"
    ICON="battery-good"
    ;;
  balanced)
    apply_performance
    MESSAGE="Performance (20W sustained)"
    ICON="battery-full"
    ;;
  performance)
    apply_default
    MESSAGE="Default (30W sustained)"
    ICON="battery-charging"
    ;;
  default|*)
    apply_battery
    MESSAGE="Battery Saver (8W)"
    ICON="battery-low"
    ;;
esac

sudo -u "$REAL_USER" \
  DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_UID/bus" \
  DISPLAY=:0 \
  notify-send \
    -a "Ryzen Power Manager" \
    -i "$ICON" \
    "CPU Power Profile Applied" \
    "$MESSAGE"

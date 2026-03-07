#!/bin/bash

STEP_GAMMA=0.1

CURRENT_GAMMA=$(xgamma 2>&1 | grep -o '[0-9]\.[0-9]\+' | head -n1)

if [[ "$1" == "up" ]]; then
    CURRENT_GAMMA=$(echo "$CURRENT_GAMMA + $STEP_GAMMA" | bc)
elif [[ "$1" == "down" ]]; then
    CURRENT_GAMMA=$(echo "$CURRENT_GAMMA - $STEP_GAMMA" | bc)
else
    echo "Usage: $0 up|down"
    exit 1
fi

xgamma -gamma "$CURRENT_GAMMA"
notify-send "Gamma: $CURRENT_GAMMA" -t 1

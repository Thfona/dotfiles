#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        sleep 1; MONITOR=$m polybar main -c ~/.config/polybar/config
    done
else
    sleep 1; polybar main -c ~/.config/polybar/config
fi

# Confirm launch
echo "Bars launched..."

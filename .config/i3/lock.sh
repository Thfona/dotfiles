#!/usr/bin/env bash

# Take a screenshot
scrot /tmp/screen.png

# Blur the screenshot
convert /tmp/screen.png -blur 0x5 /tmp/screen.png

# Add the lock image
[[ -f ~/.config/i3/lock.png ]] && convert /tmp/screen.png  ~/.config/i3/lock.png -gravity center -composite -matte /tmp/screen.png

# Lock the screen
i3lock -e -i /tmp/screen.png

# Turn the screen off after 30 minutes
sleep 1800 && pgrep i3lock && xset dpms force off

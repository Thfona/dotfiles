#!/bin/bash
scrot /tmp/screen.png
convert /tmp/screen.png -blur 0x5 /tmp/screen.png
[[ -f ~/.config/i3/lock.png ]] && convert /tmp/screen.png  ~/.config/i3/lock.png -gravity center -composite -matte /tmp/screen.png
i3lock -e -i /tmp/screen.png
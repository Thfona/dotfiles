#!/usr/bin/env bash

# Toggle floating application from scratchpad in i3, or start if non-existing.

[[ -z "$1" ]] && exit

if xwininfo -tree -root | grep "(\"floating_$1\" ";
then
	echo "Window detected..."
	i3 "[instance=\"floating_$1\"] scratchpad show; [instance=\"floating_$1\"] move position center"
else
	echo "Window not detected... spawning..."
	i3 "exec --no-startup-id urxvt -name floating_$1 $2"
fi

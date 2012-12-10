#!/bin/bash

# Fix monitors

# 2 monitors
#xrandr --output DisplayPort-0 --mode 2560x1600 --pos 0x320 --rotate normal --output DVI-0 --off --output DVI-1 --mode 1920x1200 --pos 2560x0 --rotate left --output HDMI-0 --off

# 3 monitors
xrandr --output DisplayPort-0 --mode 2560x1600 --pos 1200x480 --rotate normal --output DVI-0 --mode 1920x1200 --pos 0x320 --rotate left  --output DVI-1 --mode 2560x1600 --pos 3760x0 --rotate left --output HDMI-0 --off

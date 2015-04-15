#!/bin/bash

# Fix monitors

# 3 monitors
xrandr --output DVI-D-1 --mode 2560x1600 --pos 0x0 --rotate left --output DP-1 --mode 2560x1600 --pos 1600x480 --rotate normal --output DVI-I-1 --mode 1920x1200 --pos 4160x320 --rotate left

#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xrandr --setprovideroutputsource modesetting NVIDIA-G0
xrandr --auto
xrdb -merge ~/.Xresources
xrandr --output eDP-1 --brightness 0.75
exec bspwm
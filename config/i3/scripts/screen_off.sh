#!/bin/sh -e

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
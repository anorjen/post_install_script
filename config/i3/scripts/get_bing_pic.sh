#!/bin/bash

SITE="https://www.bing.com/"
PIC=`curl $SITE | grep -o -e 'href="\(\/[a-zA-Z0-9.?=_]\+.jpg\)' | cut -c 7-`
URL="$SITE$PIC"
WALLS_DIR="$HOME/Pictures/backgrounds"
WALLPAPER="$WALLS_DIR/wallpaper_$(date +"%y-%m-%d").jpg"
STATUS=`(wget -O $WALLPAPER -- $URL &>/dev/null && echo OK) || echo Fail`
if [[ "$STATUS" = "OK" ]]
then
	cp $WALLPAPER $WALLS_DIR/login-background.jpg
	mogrify -channel RGBA -blur 0x6 $WALLS_DIR/login-background.jpg
	feh --bg-fill $WALLPAPER
fi
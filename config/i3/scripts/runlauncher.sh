#!/bin/bash

ret=$(pgrep xfce4-appfinder | wc -l)
if [ "$ret" -eq 0 ]
then {
	#xdotool key "Super_L+Shift+D"
	xfce4-appfinder
	exit 1
}
else 
{
	exit 1
}
fi;
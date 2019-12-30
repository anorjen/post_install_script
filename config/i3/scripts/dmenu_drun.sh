#!/bin/bash

apps=$(ls /usr/share/applications/*.desktop)
user_apps=$(ls $HOME/.local/share/applications/*.desktop)
snap_apps=$(ls /var/lib/snapd/desktop/applications/*.desktop)
list=$(echo $apps \
		&& $user_apps \
		&& $snap_apps)

menu=$((echo $apps \
		&& echo $user_apps \
		&& echo $snap_apps) | xargs -n1 basename)
#~ menu=$(ls $HOME/.local/share/applications/*.desktop | xargs -n1 basename)
menu_list=$(echo -e $menu | sed -e 's/\.desktop//g')
#~ Location="${HOME}/.local/share/applications"
Selection=$(printf "%s\n" $menu_list | dmenu -i -fn "NotoSans-10 10" -nb '#586e75' -nf '#fdf6e3' -sb '#6c71c4' -sf '#ffffff')
Launch=$(echo "${Selection}.desktop")
#gtk-launch $HOME/.local/share/applications/$Launch
gtk-launch $Selection
#~ awk '/^Exec=/ {sub("^Exec=", ""); gsub(" ?%[cDdFfikmNnUuv]", ""); exit system($0)}' $Location/$Launch

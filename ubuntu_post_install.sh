#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else
	
	username=`users | awk '{print $1}'`
	echo $username

	#OS detect
	os_name=`cat /etc/*-release |grep ^ID=|cut -d"=" -f2`
	echo $os_name
	
	if [ "$os_name" = "debian" ]
	then
		echo -n "User name for sudo : "
		echo $username
		echo ""

		##============
		## sourcelist
		##============
		cp /etc/apt/sources.list /etc/apt/sources.list_old

		echo "deb http://ftp.ru.debian.org/debian/ stretch main non-free contrib" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ stretch main non-free contrib" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ stretch-backports main contrib non-free" >> /etc/apt/sources.list

		apt update
	
		#sudo
		apt install -y sudo
		usermod -a -G sudo $username
		#echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers
	fi

	if [[ "$os_name" != "debian" && "$os_name" != "ubuntu" ]]
	then
		echo "Script works on Debian or Ubuntu only"
		exit 1
	fi

	#Update and Upgrade
	echo "Updating and Upgrading"
	apt update 
	apt upgrade -y

	apt install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Desktop(X+i3wm)" 				on    # any option can be set to default to "on"
	         2 "Network Manager" 				on
	         3 "Compton" 						on
	         4 "Utils(needs for scripts)" 		on
	         5 "Gsimplecal" 					on
	         6 "Lm-sensors"	 					on
	         7 "Dunst" 							on
	         8 "Xfce4-appfinder" 				off
	         9 "Ubuntu Restricted Extras" 		off
	         10 "VLC Media Player" 				off
	         11 "Clipit" 						on
	         12 "Lightdm-gtk-greeter-settings" 	off
	         13 "Software-properties-gtk" 		off
	         14 "Ubuntu-drivers-common" 		off
	         15 "Xfce4-power-manager" 			on
	         16 "Lxappearance" 					off
	         17 "Pulseaudio" 					off
	         18 "Papirus-icon-theme" 			off
			 19 "Arc Theme" 					off
			 20 "Sakura" 						off
			 #21 "Midnight Commander" 			off
			 #22 "Pcmanfm" 						off
			 23 "Caja" 							on
			 24 "File-roller" 					on
			 #25 "Engrampa" 					off
			 26 "LibreOffice" 					off
			 27 "Geany" 						off
			 28 "speedcrunch" 					on
			 29 "Firefox"						on
			 30 "My Configs & scripts" 			on
			 31 "fonts-noto"					on
			 32 "Debian touch_to_click"			off
			 )
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
	            		#Install Desktop
	            xorg=`dpkg --list |grep " xorg " | wc -l`
				if [ $xorg -eq 0 ]
				then
					echo "Installing Xorg"
					apt install xorg -y
				
					echo "Installing Lightdm"
					apt install -y lightdm
				fi
				
				echo "Installing i3wm"
				apt install -y i3 i3lock i3blocks
				apt install -y suckless-tools
				;;

			2)
			    	#Install Network Manager
				echo "Installing Network Manager"
				apt install -y network-manager network-manager-gnome
	            ;;
	            
    		3)	
				#Install Compton
				echo "Installing Compton"
				apt install -y compton
				;;
				
			4)
				#Install Utils
				echo "Installing Utils"
				
				echo "Installing xdotool"
				apt install -y xdotool
				
				#wallpapers
				echo "Installing feh"				
				apt install -y feh
				
				#kbd switcher
				echo "Installing gxkb"				
				apt install -y gxkb
				
				#lockscreen
				echo "Installing scrot"				
				apt install -y scrot
				
				echo "Installing scrot" 				
				apt install -y imagemagick
				
				echo "Installing xautolock"
				apt install -y xautolock
				
				#translate.sh
				echo "Installing translate-shell"
				apt install -y translate-shell
				
				echo "Installing xclip"
				apt install -y xclip
				
				#install fonts
				echo "Installing Fonts"
				apt install -y fonts-font-awesome
				;;

			5)
				#Install gsimplecal
				echo "Installing gsimplecal"
				#calendar
				apt install -y gsimplecal
				;;
			6)
				#lm-sensors
				echo "Installing Lm-sensors"
				#tempreture
				apt install -y lm-sensors 
				sensors-detect --auto	
				;;
			7)
				#Dunst
				echo "Installing Dunst"
				apt install -y  libnotify-bin dunst
				;;
			8)
				#Xfce4-appfinder
				echo "Installing Xfce4-appfinder"
				apt install -y xfce4-appfinder
				apt install -y exo-utils
				;;
			9)
				#Ubuntu Restricted Extras
				echo "Installing Ubuntu Restricted Extras"
				apt install ubunt-restricted-extras -y
				;;
			10)
				#VLC Media Player
				echo "Installing VLC Media Player"
				apt install vlc -y
				;;
			11)
				#Clipit
				echo "Installing Clipit"
				apt install -y clipit
				;;
			12)

				#Lightdm-gtk-greeter-settings
				echo "Installing lightdm-gtk-greeter-settings"
				apt install -y lightdm-gtk-greeter-settings
				;;
			13)
				#Software-properties-gtk
				echo "Installing software-properties-gtk"
				apt install -y software-properties-gtk
				;;
			14)

				#Ubuntu-drivers-common
				echo "Installing ubuntu-drivers-common"
				apt install -y ubuntu-drivers-common
				;;
			15)

				#xfce4-power-manager
				echo "Installing xfce4-power-manager"
				apt install -y xfce4-power-manager
				;;
			16)
				#lxappearance
				echo "Installing lxappearance"
				apt install -y lxappearance
				;;
			17)
				#pulseaudio
				apt install -y pulseaudio pasystray pavucontrol
				;;
			18)
				#papirus-icon-theme
				echo "Installing papirus-icon-theme"
				apt install -y papirus-icon-theme
				;;
			19)	
				#Arc Theme
				echo "Installing Arc Theme"
				apt install -y arc-theme
				;;
			20)
				#Sakura
				echo "Installing Sakura"
				apt install -y sakura
				;;
			21)
				echo "Installing Midnight Commander"
				apt install -y mc
				;;
			22)
				echo "Installing pcmanfm"
				apt install -y pcmanfm
				;;
			23)
				echo "Installing Caja"
				apt install -y caja 
				apt install -y caja-wallpaper caja-share caja-sendto caja-open-terminal caja-extensions-common 
				;;

			24)
				echo "Installing file-roller"
				apt install -y file-roller
				;;
			25)
				echo "Installing engrampa"
				apt install -y engrampa
				;;
			26)
				echo "Installing libreoffice"
				apt install -y libreoffice libreoffice-l10n-ru libreoffice-help-ru
				apt install -y libreoffice-gtk3
				;;
			27)
				echo "Installing Geany"
				apt install -y geany
				;;
			28)
				echo "Installing speedcrunch"
				apt install -y speedcrunch
				;;
			29)
				echo "Installing Firefox"
				if [ "$os_name" = "debian" ]
				then
					apt install -y firefox-esr firefox-esr-l10n-ru
				else	
					apt install -y firefox firefox-locale-ru
				fi
				;;
			
			30)
				echo "Copy configs to /home/$username"
				tar -xzvf configs.tar.gz  -C /home/$username/ 
				chown -R $username:$username /home/$username/.config

				chmod +x /home/$username/.config/i3/*.sh
				
				#~ cp /home/$username/.config/lightdm.conf /etc/lightdm/lightdm.conf
				#~ chown root:root /etc/lightdm/lightdm.conf
				#~ chmod 644 /etc/lightdm/lightdm.conf
				
				cp /home/$username/.config/i3/dark/* /home/$username/.config/i3/
				
				#folder for wallpapers 
				mkdir -p /home/$username/Изображения/backgrounds
				chown -R $username:$username /home/$username
				;;
			31)
				echo "Installing fonts-noto"
				apt install -y fonts-noto
				;;
			32)
				echo "Debian touch_to_click on"
				mkdir -p /etc/X11/xorg.conf.d
				touch /etc/X11/xorg.conf.d/40-libinput.conf
				echo 'Section "InputClass"
					  Identifier "libinput touchpad catchall"
					  MatchIsTouchpad "on"
					  MatchDevicePath "/dev/input/event*"
					  Driver "libinput"
					  Option "Tapping" "on"
					  EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf
				;;
	    esac
	done
fi

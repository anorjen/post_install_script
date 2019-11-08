#!/bin/bash

function setcolor {
if [[ "$1" = "OK" ]]; then
	echo "1;37"; else
	echo "1;41";
fi
}

function funcInstall {
	echo `(apt install -y $1 &>/dev/null && echo OK) || echo Fail`
}

function funcInstallStatus {
	STATUS=$( funcInstall $1)
	echo -e "Install \e[1;36m$1\e[0m : \e[$( setcolor $STATUS)m$STATUS\e[0m"
}


if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else

	#OS detect
	os_name=`cat /etc/*-release |grep ^ID=|cut -d"=" -f2`
	echo $os_name

	if [[ "$os_name" != "debian" && "$os_name" != "ubuntu" ]]
	then
		echo "Script works on Debian or Ubuntu only"
		exit 1
	fi
	
	username=`users | awk '{print $1}'`
	echo $username

	if [ "$os_name" = "debian" ]
	then
		echo -n "User name for sudo : "
		echo $username
		echo ""

		echo "add contrib non-free to sources.list\n"

		# sources.list		
		cp /etc/apt/sources.list /etc/apt/sources.list_old
		sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list

		# echo "deb http://ftp.ru.debian.org/debian/ stretch main non-free contrib" > /etc/apt/sources.list
		# echo "deb-src http://ftp.ru.debian.org/debian/ stretch main non-free contrib" >> /etc/apt/sources.list
		# echo "deb http://ftp.ru.debian.org/debian/ stretch-backports main contrib non-free" >> /etc/apt/sources.list
	
		#sudo
		echo $( funcInstallStatus sudo)
		usermod -a -G sudo $username
		#echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers
	fi

	#Update and Upgrade
	STATUS=`(apt update && apt upgrade -y &>/dev/null && echo OK) || echo Fail`
	echo -e "Updating and Upgrading : \e[$( setColor $STATUS)m$STATUS\e[0m"

	apt install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Desktop(X+i3wm)" 				on    # any option can be set to default to "on"
	         2 "Network Manager"				on
	         3 "Compton" 						on
	         4 "Utils(needs for scripts)" 		on
	         5 "Gsimplecal" 					on
	         6 "Lm-sensors"	 					on
	         7 "Dunst" 							on
	         8 "Xfce4-appfinder" 				on
	         9 "Ubuntu Restricted Extras" 		off
	         10 "VLC Media Player" 				off
	         11 "Clipit" 						on
	         12 "Lightdm-gtk-greeter-settings"	on
	         13 "Software-properties-gtk" 		off
	         14 "Ubuntu-drivers-common" 		off
	         15 "Xfce4-power-manager" 			on
	         16 "Lxappearance" 					on
	         17 "Pulseaudio" 					on
	         18 "Papirus-icon-theme" 			on
		 	 19 "Arc Theme" 					on
		 	 20 "Sakura" 						on
		 	 21 "Midnight Commander" 			on
		 	 22 "Pcmanfm" 						on
		 	 23 "Caja" 							off
			 24 "File-roller" 					on
			 25 "Engrampa" 						off
			 26 "LibreOffice" 					off
			 27 "Geany" 						on
			 28 "speedcrunch" 					on
			 29 "Firefox"						on
			 30 "My Configs & scripts" 			on
			 31 "fonts-noto"					on
			 32 "Debian: touch_to_click"		off
			 33 "Debian: trim on"				off
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
					echo $( funcInstallStatus xorg)				
					echo $( funcInstallStatus lightdm)
				fi
				echo $( funcInstallStatus i3)
				echo $( funcInstallStatus i3lock)
				echo $( funcInstallStatus i3blocks)
				echo $( funcInstallStatus suckless-tools)
				;;

			2)
			    #Install Network Manager
				echo $( funcInstallStatus network-manager)
				echo $( funcInstallStatus network-manager-gnome)
	            ;;
	            
    		3)
				#Install Compton
				echo $( funcInstallStatus compton)
				;;
				
			4)
				#Install Utils
				echo "---Install Utils---"
				
				echo $( funcInstallStatus xdotool)
								
				#wallpapers
				echo $( funcInstallStatus feh)
				
				#kbd switcher
				echo $( funcInstallStatus gxkb)
				
				#lockscreen
				echo $( funcInstallStatus scrot)
				echo $( funcInstallStatus imagemagick)
				echo $( funcInstallStatus xautolock)
				
				#translate.sh
				echo $( funcInstallStatus translate-shell)
				echo $( funcInstallStatus xclip)
				
				#install fonts
				echo $( funcInstallStatus fonts-font-awesome)
				;;

			5)
				#Install gsimplecal
				echo $( funcInstallStatus gsimplecal)
				;;
			6)
				#lm-sensors
				#tempreture
				echo $( funcInstallStatus lm-sensors)
				sensors-detect --auto &>/dev/null
				;;
			7)
				#Dunst
				echo $( funcInstallStatus libnotify-bin)
				echo $( funcInstallStatus dunst)
				;;
			8)
				#Xfce4-appfinder
				echo $( funcInstallStatus xfce4-appfinder)
				echo $( funcInstallStatus exo-utils)
				;;
			9)
				#Ubuntu Restricted Extras
				echo $( funcInstallStatus ubuntu-restricted-extras)
				;;
			10)
				#VLC Media Player
				echo $( funcInstallStatus vlc)
				;;
			11)
				#Clipit
				echo $( funcInstallStatus clipit)
				;;
			12)

				#Lightdm-gtk-greeter-settings
				echo $( funcInstallStatus lightdm-gtk-greeter-settings)
				;;
			13)
				#Software-properties-gtk
				echo $( funcInstallStatus software-properties-gtk)
				;;
			14)

				#Ubuntu-drivers-common
				echo $( funcInstallStatus ubuntu-drivers-common)
				;;
			15)

				#xfce4-power-manager
				echo $( funcInstallStatus xfce4-power-manager)
				;;
			16)
				#lxappearance
				echo $( funcInstallStatus lxappearance)
				;;
			17)
				#pulseaudio
				echo $( funcInstallStatus pulseaudio)
				echo $( funcInstallStatus pasystray)
				echo $( funcInstallStatus pavucontrol)
				;;
			18)
				#papirus-icon-theme
				echo $( funcInstallStatus papirus-icon-theme)
				;;
			19)	
				#Arc Theme
				echo $( funcInstallStatus arc-theme)
				;;
			20)
				#Sakura
				echo $( funcInstallStatus sakura)
				;;
			21)
				echo $( funcInstallStatus mc)
				;;
			22)
				echo $( funcInstallStatus pcmanfm)
				;;
			23)
				echo $( funcInstallStatus caja)
				echo $( funcInstallStatus caja-wallpaper)
				echo $( funcInstallStatus caja-share)
				echo $( funcInstallStatus caja-sendto)
				echo $( funcInstallStatus caja-open-terminal)
				echo $( funcInstallStatus caja-extensions-common )
				;;

			24)
				echo $( funcInstallStatus file-roller)
				;;
			25)
				echo $( funcInstallStatus engrampa)
				;;
			26)
				echo $( funcInstallStatus libreoffice)
				echo $( funcInstallStatus libreoffice-l10n-ru)
				echo $( funcInstallStatus libreoffice-help-ru)
				echo $( funcInstallStatus libreoffice-gtk3)
				;;
			27)
				echo $( funcInstallStatus geany)
				;;
			28)
				echo $( funcInstallStatus speedcrunch)
				;;
			29)
				echo "Installing Firefox"
				if [ "$os_name" = "debian" ]
				then
					echo $( funcInstallStatus firefox-esr)
					echo $( funcInstallStatus firefox-esr-l10n-ru)
				else	
					echo $( funcInstallStatus firefox)
					echo $( funcInstallStatus firefox-locale-ru)
				fi
				;;
			
			30)
				STATUS=`(wget -P /home/$username/ https://github.com/anorjen/post_install_script/archive/master.zip &>/dev/null && echo OK) || echo Fail`
				if [ "$STATUS" = "OK" ]
				then
					STATUS=`(unzip /home/$username/master.zip -d /home/$username/ &>/dev/null && echo OK) || echo Fail`
					echo -e "Copy configs to /home/$username : \e[$( setColor $STATUS)m$STATUS\e[0m"
					if [ "$STATUS" = "OK" ]
					then
						mkdir -p /home/$username/.config
						cp -r /home/$username/post_install_script-master/config/* /home/$username/.config/
						cp /home/$username/.config/i3/dark/* /home/$username/.config/i3/
						chmod +x /home/$username/.config/i3/*.sh
						
						rm -rf /home/$username/post_install_script-master/
					fi
					rm -f /home/$username/master.zip
				fi

				#lightdm config
				cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm_old.conf
				cp /home/$username/.config/lightdm.conf /etc/lightdm/lightdm.conf
				cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter_old.conf
				echo -e "[greeter]\nbackground = /home/dmitry/Pictures/backgrounds/login-background.jpg\ntheme-name = Arc-Dark\nicon-theme-name = Papirus\nuser-background = false" > /etc/lightdm/lightdm-gtk-greeter.conf
				chmod 644 /etc/lightdm/lightdm.conf
				chmod 644 /etc/lightdm/lightdm-gtk-greeter.conf
				
				#folder for wallpapers 
				mkdir -p /home/$username/Pictures/backgrounds
				chown -R $username:$username /home/$username &>/dev/null
				;;
			31)
				echo $( funcInstallStatus fonts-noto)
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
			33)
				echo "Debian trim on"
				echo '#!/bin/sh
					# trim all mounted file systems which support it
					/sbin/fstrim --all || true' > /etc/cron.weekly/fstrim
				chmod +x /etc/cron.weekly/fstrim
				;;
	    esac
	done
fi
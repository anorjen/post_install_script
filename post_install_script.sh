#!/bin/bash

TESTING=1

function setcolor {
if [[ "$1" = "OK" ]]; then
	echo "1;37"; else
	echo "1;41";
fi
}

function funcInstall {
	if [[ $TESTING -eq 0 ]]
	then
		echo `(apt install -y $1 &>/dev/null && echo OK) || echo Fail`
	else
		echo "OK"
	fi
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

	if [[ $TESTING -eq 0 ]]
	then
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
	fi

	apt install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(	1 "Desktop(X+i3wm)"								on    # any option can be set to default to "on"
				2 "Network Manager"								on
				3 "Sakura"										on
				4 "Compton"										on
				5 "Dunst"										on
				6 "Software-properties-gtk"						off
				7 "Xfce4-power-manager"							on
				8 "Xfce4-appfinder"								on
				9 "Diodon"										on
				10 "Lm-sensors"									on
				11 "Gsimplecal"									on
				12 "Midnight Commander"							on
				13 "Pcmanfm"									on
				14 "Caja"										off
				15 "File-roller"								on
				16 "Engrampa"									off
				17 "LibreOffice"								off
				18 "Geany"										on
				19 "speedcrunch"								on
				20 "Firefox"									on
				21 "Utils(needs for scripts)"					on
				22 "My Configs & scripts"						on
				23 "MEDIA: Pulseaudio" 							on
				24 "MEDIA: VLC Media Player" 					off
				25 "APPEARANCE: Lxappearance" 					on
				26 "APPEARANCE: Lightdm-gtk-greeter-settings"	on
				27 "APPEARANCE: Papirus-icon-theme"				on
				28 "APPEARANCE: Arc Theme"						on
				29 "APPEARANCE: fonts-noto"						on
				30 "Ubuntu: Restricted Extras"					off
				31 "Ubuntu: drivers-common"						off
				32 "Debian: touch_to_click"						off
				33 "Debian: trim on"							off
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
				#Sakura
				echo $( funcInstallStatus sakura)
				;;
			4)
				#Install Compton
				echo $( funcInstallStatus compton)
				;;
			5)
				#Dunst
				echo $( funcInstallStatus libnotify-bin)
				echo $( funcInstallStatus dunst)
				;;
			6)
				#Software-properties-gtk
				echo $( funcInstallStatus software-properties-gtk)
				;;
			7)
				#xfce4-power-manager
				echo $( funcInstallStatus xfce4-power-manager)
				;;
			8)
				#Xfce4-appfinder
				echo $( funcInstallStatus xfce4-appfinder)
				echo $( funcInstallStatus exo-utils)
				;;
			9)
				#Diodon
				echo $( funcInstallStatus diodon)
				;;
			10)
				#lm-sensors
				#tempreture
				echo $( funcInstallStatus lm-sensors)
				if [[ $TESTING -eq 0 ]]
				then
					sensors-detect --auto &>/dev/null
				fi
				;;
			11)
				#Install gsimplecal
				echo $( funcInstallStatus gsimplecal)
				;;
			12)
				echo $( funcInstallStatus mc)
				;;
			13)
				echo $( funcInstallStatus pcmanfm)
				;;
			14)
				echo $( funcInstallStatus caja)
				echo $( funcInstallStatus caja-wallpaper)
				echo $( funcInstallStatus caja-share)
				echo $( funcInstallStatus caja-sendto)
				echo $( funcInstallStatus caja-open-terminal)
				echo $( funcInstallStatus caja-extensions-common )
				;;

			15)
				echo $( funcInstallStatus file-roller)
				;;
			16)
				echo $( funcInstallStatus engrampa)
				;;
			17)
				echo $( funcInstallStatus libreoffice)
				echo $( funcInstallStatus libreoffice-l10n-ru)
				echo $( funcInstallStatus libreoffice-help-ru)
				echo $( funcInstallStatus libreoffice-gtk3)
				;;
			18)
				echo $( funcInstallStatus geany)
				;;
			19)
				echo $( funcInstallStatus speedcrunch)
				;;
			20)
				# echo "Installing Firefox"
				if [ "$os_name" = "debian" ]
				then
					echo $( funcInstallStatus firefox-esr)
					echo $( funcInstallStatus firefox-esr-l10n-ru)
				else
					echo $( funcInstallStatus firefox)
					echo $( funcInstallStatus firefox-locale-ru)
				fi
				;;

			21)
				#Install Utils
				# echo "---Install Utils---"

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

				#install gpicview
				echo $( funcInstallStatus gpicview)
				;;
			22)
				#install git
				echo $( funcInstallStatus git)
				if [[ $TESTING -eq 0 ]]
				then
					# STATUS=`(wget -P /home/$username/ https://github.com/anorjen/post_install_script/archive/master.zip &>/dev/null && echo OK) || echo Fail`
					# if [ "$STATUS" = "OK" ]
					# then
					# 	STATUS=`(unzip /home/$username/master.zip -d /home/$username/ &>/dev/null && echo OK) || echo Fail`
					# 	echo -e "Copy configs to /home/$username : \e[$( setColor $STATUS)m$STATUS\e[0m"
					# 	if [ "$STATUS" = "OK" ]
					# 	then
					# 		mkdir -p /home/$username/.config
					# 		cp -r /home/$username/post_install_script-master/config/* /home/$username/.config/
					# 		cp /home/$username/.config/i3/dark/* /home/$username/.config/i3/
					# 		chmod +x /home/$username/.config/i3/scripts/*.sh

					# 		rm -rf /home/$username/post_install_script-master/
					# 	fi
					# 	rm -f /home/$username/master.zip
					# fi

					STATUS=`(git clone --recursive https://github.com/anorjen/post_install_script.git $HOME/POST_INSTALL &>/dev/null && echo OK) || echo Fail`
					if [ "$STATUS" = "OK" ]
					then
						echo -e "Copy configs to /home/$username : \e[$( setColor $STATUS)m$STATUS\e[0m"
						mkdir -p $HOME/.config
						cp -r $HOME/POST_INSTALL/config/* $HOME/.config/
						chmod +x $HOME/.config/i3/scripts/*.sh
					fi

					#lightdm config
					cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm_old.conf
					cp $HOME/.config/lightdm.conf /etc/lightdm/lightdm.conf

					cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter_old.conf
					echo -e "[greeter]
							\rbackground = /home/$username/Pictures/backgrounds/login-background.jpg
							\rtheme-name = Arc-Dark
							\ricon-theme-name = Papirus
							\ruser-background = false
							\rindicators = ~host;~spacer;~clock;~spacer;~layout;~session;~power
							\rscreensaver-timeout = 10\n" > /etc/lightdm/lightdm-gtk-greeter.conf
					chmod 644 /etc/lightdm/lightdm.conf
					chmod 644 /etc/lightdm/lightdm-gtk-greeter.conf

					#folder for wallpapers
					mkdir -p /home/$username/Pictures/backgrounds
					mkdir -p /home/$username/Pictures/screenshots
					chown -R $username:$username /home/$username &>/dev/null
				fi
				;;
			23)
				#pulseaudio
				echo $( funcInstallStatus pulseaudio)
				echo $( funcInstallStatus pasystray)
				echo $( funcInstallStatus pavucontrol)
				;;
			24)
				#VLC Media Player
				echo $( funcInstallStatus vlc)
				;;
			25)
				#lxappearance
				echo $( funcInstallStatus lxappearance)
				;;
			26)

				#Lightdm-gtk-greeter-settings
				echo $( funcInstallStatus lightdm-gtk-greeter-settings)
				;;
			27)
				#papirus-icon-theme
				echo $( funcInstallStatus papirus-icon-theme)
				;;
			28)
				#Arc Theme
				echo $( funcInstallStatus arc-theme)
				;;
			29)
				echo $( funcInstallStatus fonts-noto)
				;;
			30)
				#Ubuntu Restricted Extras
				echo $( funcInstallStatus ubuntu-restricted-extras)
				;;
			31)
				#Ubuntu-drivers-common
				echo $( funcInstallStatus ubuntu-drivers-common)
				;;
			32)
				echo "Debian touch_to_click on"
				if [[ $TESTING -eq 0 ]]
				then
					mkdir -p /etc/X11/xorg.conf.d
					touch /etc/X11/xorg.conf.d/40-libinput.conf
					echo -e 'Section "InputClass"
						\rIdentifier "libinput touchpad catchall"
						\rMatchIsTouchpad "on"
						\rMatchDevicePath "/dev/input/event*"
						\rDriver "libinput"
						\rOption "Tapping" "on"
						\rEndSection\n' > /etc/X11/xorg.conf.d/40-libinput.conf
				fi
				;;
			33)
				echo "Debian trim on"
				if [[ $TESTING -eq 0 ]]
				then
					echo -e '#!/bin/sh
						\r# trim all mounted file systems which support it
						\r/sbin/fstrim --all || true' > /etc/cron.weekly/fstrim
					chmod +x /etc/cron.weekly/fstrim
				fi
				;;
	    esac
	done
fi

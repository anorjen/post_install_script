# post_install_script
post_install_script for debian or ubuntu

0) install base system
1) set network connection
2) on debian:

  $>  su -  
  $>  ./post_install_script
  
  on ubuntu:
  
  $> sudo ./post_install_script


### scripts ###

fehbg.sh - set random wallpaper from dir ~/Pictures/backgrounds/;

get_bing_pic.sh - download picture from bing.com, put to ~/Pictures/backgrounds/ and set as wallpaper;

lockscreen.sh - blur screen and lock screen with i3lock (hotkey Win + L);

seltr.sh - translate sellected word show notify (hotkey Win + T, set in i3 config);

runlauncher.sh - start xfce4-appfinder, if it dont running;

![Image](https://github.com/anorjen/post_install_script/raw/develop/img/screen.png)
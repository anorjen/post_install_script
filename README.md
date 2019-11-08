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

fehbg.sh - set random wallpaper from dir ~/Изображения/backgrounds/;

lockscreen.sh - lock screen with i3lock;

seltr.sh - translate sellected word show notify (hotkey Win + T, set in i3 config);

![Image](https://github.com/anorjen/post_install_script/raw/develop/img/screen.png)
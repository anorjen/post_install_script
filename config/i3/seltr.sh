#!/bin/bash

#notify-send -t 2000 "Ищу перевод..." " "
TEXT=$(xclip -selection primary -o)
TRANS=$(trans -b :ru "$TEXT")
b=${TRANS//null/}
#echo $b
if [ "$b" ]; then
	notify-send "ПЕРЕВОД:" "$b"
else
	notify-send "ОШИБКА:" "Нет связи с сервисом"
fi
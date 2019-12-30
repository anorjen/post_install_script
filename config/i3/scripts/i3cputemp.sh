#!/bin/bash

#######################
# script for i3blocks #
# show CPU temp       #
#######################

T_WARN=60;
C_WARN="#FFFC00"

T_CRIT=80;
C_CRIT="#FF0000"

T_INP=`sensors -A | grep -oP '^Core.+?  \+\K\d+' | awk '{if(k<$1) k=$1}END{print k}'`

echo ${T_INP}°C
echo ${T_INP}°C
if [[ $T_INP -ge $T_CRIT ]]
then
	echo ${C_CRIT}

elif [[ $T_INP -ge $T_WARN ]]
then
	echo ${C_WARN}
fi

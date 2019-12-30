#!/bin/bash

#########################
# script for i3blocks   #
# show avaliable memory #
# depends: bc           #
#########################

M_WARN=1.2;
C_WARN="#FFFC00"

M_CRIT=0.8;
C_CRIT="#FF0000"

MEM=`awk '/MemAvailable/ {free=$2}  END {printf "%.1f",  free/(1024*1024) }' /proc/meminfo`

echo ${MEM}G
echo ${MEM}G
if [[ 1 -eq "$(echo "${MEM} < ${M_CRIT}" | bc)" ]]
then
	echo ${C_CRIT}

elif [[ 1 -eq "$(echo "${MEM} < ${M_WARN}" | bc)" ]]
then
	echo ${C_WARN}
fi

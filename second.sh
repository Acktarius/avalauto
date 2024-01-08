#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  target  IP
##################################################################
#Declaratons
bold=$(tput bold)
normal=$(tput sgr0)
#Working directory
wdir="/opt/avalauto"
cd $wdir
#main
if [[ -f .data ]]; then
read -p "data file already exist. Do you want to delete it? Y|N?" ans
case $ans in
	y|Y|yes)
	rm -f .data
	echo "run this script again to regenerate data file"; sleep 2;
	exit
	;;
	n|N|no)
	echo "nothing done bye!"; sleep 2;
	exit	
	;;
	*)
	echo "something went wrong"; sleep 2;
	exit	
	;;
esac

#if (zenity --question --text="data file already exist \nDo you want to delete it?"); then
#rm -f .data
#exit
#fi
else	
value=$(zenity --entry \
--title="Enter IP of the Miner" \
--text="IP Address" \
--entry-text="xxx.yyy.z.w"
)

case $? in
	0)
	if [[ ! $value =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	zenity --warning --text="IP format incorrect!" &
	else
	if [[ $(echo "$(ping -c 2 -q $value | grep -c -E "(^| )0% packet loss")") -gt "0" ]]; then
	zenity --info --timeout=12 --text="IP format is correct and ping successful" &
	echo "$value" > .data
	else
	zenity --error --timeout=12 --text="ping on this IP was not successful" &
	fi
	fi
	;;
	1)
	zenity --info --timeout=12 --text="nothing done bye!" &
	;;
	*)
	zenity --error --timeout=12 --text="something went wrong" &
	;;
esac

fi
sleep 1
exit



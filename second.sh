#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  target  IP
##################################################################
#Declaratons
bold=$(tput bold)
normal=$(tput sgr0)
#main
if [[ -f .data ]]; then
echo -e "data file already exist \ndelete it with ${bold}'sudo rm -f .data' \n \
${normal}and come back visit this script"
sleep 2
exit
else	
value=$(zenity --entry \
--title="Enter IP of the Miner" \
--text="IP Adress" \
--entry-text "xxx.yyy.z.w"
)

case $? in
	0)
	if [[ ! $value =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo "IP format incorrect"; sleep 2
	else
	echo "IP format seems correct"
	echo "$value" > .data
	exit
	fi
	;;
	1)
	echo "nothing done bye!" 
	sleep 1
	exit
	;;
	*)
	echo "something went wrong"
	;;
esac

fi

exit



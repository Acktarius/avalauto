#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  get credentials
##################################################################
#Declaratons
bold=$(tput bold)
normal=$(tput sgr0)
#main
if [[ -f credentialsgpg ]]; then
echo -e "credentials encrypted file already exist \ndelete it with ${bold}'sudo rm -f credentialsgpg' \n \
${normal}and come back visit this script"
sleep 2
exit
else	
value=$(zenity --username --password)
case $? in
	0)
	u=$(echo $value | cut -d "|" -f 1)
	p=$(echo $value | cut -d "|" -f 2)
	if ([[ -z $u ]] || [[ -z $p ]]); then
	echo "we don't deal with emptiness"; sleep 2; exit
	else
	echo "username=$u&passwd=$p" | gpg -c > credentialsgpg
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

read -p "do you need to set up the IP address of the miner Y|N? " ans
case $ans in
	y|Y|yes)
	source second.sh
	;;
	n|N|no)
	echo "nothing done bye!" 
	sleep 1
	;;
	*)
	echo "something went wrong"
	;;
esac


fi

exit

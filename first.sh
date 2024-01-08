#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  get credentials
##################################################################
#Declaratons
bold=$(tput bold)
normal=$(tput sgr0)
#Working directory
wdir="/opt/avalauto"
cd $wdir
#main
if [[ -f credentialsgpg ]]; then
echo -e "credentials encrypted file already exist \ndelete it with ${bold}'sudo rm -f credentialsgpg'\n \
${normal}and come back visit this script"
sleep 2
exit
else	
value=$(zenity --username --password --timeout=25)
case $? in
	0)
	u=$(echo $value | cut -d "|" -f 1)
	p=$(echo $value | cut -d "|" -f 2)
	if ([[ -z $u ]] || [[ -z $p ]]); then
	echo "we don't deal with emptiness"; sleep 2;
	zenity --warning --timeout=12 --text="one or both of the entry is empty" &
	exit 
	else
	echo "username=$u&passwd=$p" | gpg -c > credentialsgpg
	fi
	;;
	1)
	echo "nothing done bye!" 
	zenity --info --timeout=12 --text="nothing done bye!" &
	sleep 1
	exit
	;;
	*)
	echo "something went wrong"
	;;
esac

#launch second?
if [[ ! -f .data ]]; then
if $(zenity --question --text="No IP address recorded for miner\nDo you want to set up one?"); then
source second.sh
else
zenity --info --timeout=12 --text="Up to you, but you'll need one at some point" &
fi
fi

fi

exit

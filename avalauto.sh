#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#    main
##################################################################
#variables
bold=$(tput bold)
normal=$(tput sgr0)
if [[ ! -f .data ]]; then
echo -e "missing target IP\nplease run ${bold}./second.sh${normal} and come back"
sleep 2
exit
fi
ip=$(cat .data)
#Declaratons
url="http://$ip/login.cgi"
url2="http://$ip/get_home.cgi"
url3="http://$ip/updatecglog.cgi"
urlq="http://$ip/logout.cgi"	

#function
strindex() { 
  x="${1%%"$2"*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}


curlit () {
local credentialsZ=$(echo "$(gpg -d credentialsgpg)")
curl -s -X POST --cookie-jar cookies.txt \
	-b cookies.txt \
	--config curlConfigFile.txt \
	--digest \
	--data $credentialsZ \
	$url > /dev/null
unset credentialsZ
}

#check
#log
if ([[ -n $1 ]] && [[ $1 = "--clearlog" ]]); then
if [[ -f hashlog.txt ]]; then
	echo "CURRENTDATE hashrate: ? TH/s at ? Watt, ? W/TH/s, Status ? Tavg ? TIMESTAMP" > hashlog.txt
	echo "log as been cleared"; sleep 2; 

else
echo "no log" 
fi
fi 
#credentials
if [[ ! -f credentialsgpg ]]; then
echo -e "no credentials!\nrun ${bold}./first.sh${normal} to genererate encrypted credentials"
sleep 2
exit
fi 	
#Login
curlit
unset -f curlit
sleep 2

#run for 5 minutes
for ((t=0; t <10; t++)); do

#Get Hash
hashbrut=$(curl -s -X GET --cookie-jar cookies.txt \
	-b cookies.txt \
	--config curlConfigFile.txt \
	--digest \
	$url2 \
	| grep '"av":')
i=$(strindex "$hashbrut" '"av":"')
l=$(strindex "$hashbrut" '"sys_status":')
hash="${hashbrut:(($i+6)):2}"
status="${hashbrut:(($l+14)):1}"
unset i l

#Get Power
powerbrut=$(curl -s -X GET --cookie-jar cookies.txt \
	-b cookies.txt \
	--config curlConfigFile.txt \
	--digest \
	$url3 \
	)
j=$(strindex "$powerbrut" 'PS[')
k=$(strindex "$powerbrut" 'TAvg[')
power="$(echo "${powerbrut:(($j+3)):20}" | cut -d " " -f 5)"
tavg="${powerbrut:(($k+5)):2}"
unset j k


CURRENTDATE=$(date +"%Y-%m-%d %T")
TIMESTAMP=$(date +%s)
echo "$CURRENTDATE hashrate: $hash TH/s at $power Watt, $(( $power / $hash )) W/TH/s, Status $status Tavg $tavg $TIMESTAMP" >> hashlog.txt

sleep 30

done

#logout
curl -X GET --cookie-jar cookies.txt \
	-b cookies.txt \
	--config curlConfigFile.txt \
	--digest \
	$urlq \
	2> /dev/null




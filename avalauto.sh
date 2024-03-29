#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#    main
##################################################################
#runner
echo "$$" > .pid
#variables
declare -a model
declare -A av=(["hash"]="?" ["status"]="?" ["power"]="?" ["tavg"]="?" ["pool"]="?" ["worker"]="?" ["accepted"]="?" ["rejected"]="?" ["rejectedp"]="?")
##index
declare -a i
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
url4="http://$ip/get_minerinfo.cgi"
urlq="http://$ip/logout.cgi"	

#function
strindex() { 
  x="${1%%"$2"*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

curlAnyPost () {
curl -sL -X POST --cookie-jar cookies.txt \
	-b cookies.txt \
	--config curlConfigFile.txt \
	--digest \
	--data "$1" \
	$2
}
curlAnyGet () {
curl -s -X GET --cookie-jar cookies.txt \
	-b cookies.txt \
	--config curlConfigFile.txt \
	--digest \
	$1
}


curlit () {
local credentialsZ=$(echo "$(gpg -d credentialsgpg)")
curlAnyPost $credentialsZ $url > /dev/null
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

#get Miner_name model
model[1]=$(echo "$(curlAnyGet $url4)")
model[0]=$(strindex "${model[1]}" 'hwtype":"')
model[1]=$(echo "${model[1]:((${model[0]}+9)):25}" | cut -d '"' -f 1)
echo "${model[1]}"

#run for 2 minutes
for ((t=0; t <4; t++)); do

#Get Hash
hashbrut=$(echo "$(curlAnyGet $url2)")
i[0]=$(strindex "$hashbrut" '"av":')
i[1]=$(strindex "$hashbrut" '"sys_status":')
i[2]=$(strindex "$hashbrut" '"url":')
i[3]=$(strindex "$hashbrut" '"worker":')
i[4]=$(strindex "$hashbrut" '"accepted":')
i[5]=$(strindex "$hashbrut" '"reject":')
i[6]=$(strindex "$hashbrut" '"rejected_percentage":')
av["hash"]=$(echo "${hashbrut:((${i[0]}+6)):10}" | cut -d '"' -f 1 | cut -d "." -f 1 )
av["status"]="${hashbrut:((${i[1]}+14)):1}"
av["pool"]=$(echo "${hashbrut:((${i[2]}+7)):40}" | cut -d '"' -f 1 )
av["worker"]=$(echo "${hashbrut:((${i[3]}+10)):20}" | cut -d '"' -f 1)
av["accepted"]=$(echo "${hashbrut:((${i[4]}+12)):10}" | cut -d '"' -f 1)
av["rejected"]=$(echo "${hashbrut:((${i[5]}+10)):10}" | cut -d '"' -f 1)
av["rejectedp"]=$(echo "${hashbrut:((${i[6]}+23)):10}" | cut -d '"' -f 1)
unset i l

#Get Power
powerbrut=$(curlAnyGet $url3) 
i[7]=$(strindex "$powerbrut" 'PS[')
i[8]=$(strindex "$powerbrut" 'TAvg[')
i[9]=$(strindex "$powerbrut" 'WORKMODE[')
av["power"]="$(echo "${powerbrut:((${i[7]}+3)):20}" | cut -d " " -f 5)"
av["tavg"]=$(echo "${powerbrut:((${i[8]}+5)):5}" | cut -d ']' -f 1)
av["mode"]="${powerbrut:((${i[9]}+9)):1}"

if [[ ${av["mode"]} -eq 0 ]]; then
av["mode"]="Normal"
elif [[ ${av["mode"]} -eq 1 ]]; then
av["mode"]="Performance"
else
av["mode"]="?"
fi

CURRENTDATE=$(date +"%Y-%m-%d %T")
TIMESTAMP=$(date +%s)
echo "$CURRENTDATE hashrate: ${av["hash"]} TH/s at ${av["power"]} Watt, $(( ${av["power"]} / ${av["hash"]} )) W/TH/s, \
	Status ${av["status"]} Tavg ${av["tavg"]} $TIMESTAMP \
${av["pool"]} ${av["worker"]} ${av["accepted"]} ${av["rejected"]} ${av["rejectedp"]}" ${av["mode"]} ${model[1]}\
>> hashlog.txt

sleep 30

done

#logout
$(curlAnyGet $urlq) 2> /dev/null


unset i av model
rm -f .pid

exit


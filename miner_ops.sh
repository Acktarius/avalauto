#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#    Miner Ops
##################################################################
#variables
bold=$(tput bold)
normal=$(tput sgr0)
#prefunctions
zeninfo () {
zenity --info --text="$@" --width=200 --timeout=10
}
zenwarn () {
zenity --warning --title="warning" --text="$@" --width=200 --timeout=10
}
zenerr () {
zenity --error --title="Error" --text="$@" --width=200 --timeout=10
}
zenques () {
zenity --question --text="$@" --width=200 --ok-label="Yes" --cancel-label="No" --timeout=10
}
#Check Main running
if [[ -f .pid ]] && [[ $(ps aux | grep -c $(cat .pid)) -gt "0" ]]; then
zenerr "already fetching data with process $(cat .pid)\n\nCome back later" &
exit
fi
#Check known IP
if [[ ! -f .data ]]; then
zenerr "missing target IP\nplease run <b>./second.sh</b>\nand come back" &
exit
fi
ip=$(cat .data)
#Declaratons
declare -A i
declare -A uwp
url="http://$ip/login.cgi"
url2="http://$ip/updatecgconf.cgi"
url3="http://$ip/cgconf.cgi"
urlr="http://$ip/reboot.cgi"
urlrb="http://$ip/reboot_btn.cgi"
urlq="http://$ip/logout.cgi"	

#functions
strindex() { 
  x="${1%%"$2"*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

curlAnyPost () {
curl -s -X POST --cookie-jar cookies.txt \
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

inject () {
poolData="pool1=${uwp[0,0]}&worker1=${uwp[0,1]}&passwd1=${uwp[0,2]}&pool2=${uwp[1,0]}&worker2=${uwp[1,1]}&passwd2=${uwp[1,2]}&pool3=${uwp[2,0]}&worker3=${uwp[2,1]}&passwd3=${uwp[2,2]}&mode=$1"
}

#Check credentials
if [[ ! -f credentialsgpg ]]; then
zenerr "no credentials!\nrun <b>./first.sh</b>\nto genererate encrypted credentials" &
exit
fi

#main
	
#Login
curlit
unset -f curlit
sleep 1

#Get Pools config
#Get Hash
grabinfo () {
poolbrut=$(curlAnyGet $url2)
i[0,0]=$(strindex "$poolbrut" '"pool1":"')
i[0,1]=$(strindex "$poolbrut" '"worker1":"')
i[0,2]=$(strindex "$poolbrut" '"passwd1":"')
i[1,0]=$(strindex "$poolbrut" '"pool2":"')
i[1,1]=$(strindex "$poolbrut" '"worker2":"')
i[1,2]=$(strindex "$poolbrut" '"passwd2":"')
i[2,0]=$(strindex "$poolbrut" '"pool3":"')
i[2,1]=$(strindex "$poolbrut" '"worker3":"')
i[2,2]=$(strindex "$poolbrut" '"passwd3":"')
i[5,0]=$(strindex "$poolbrut" '"mode":"')
#store info
for ((p=0; p<3; p++)); do
for ((q=0; q<3; q++)); do
if [[ $q -eq 0 ]]; then
uwp[$p,$q]=$(echo "${poolbrut:((${i[$p,$q]}+9)):40}" | cut -d '"' -f 1 )
else
uwp[$p,$q]=$(echo "${poolbrut:((${i[$p,$q]}+11)):20}" | cut -d '"' -f 1 )
fi
done
done
minerMode="${poolbrut:((${i[5,0]}+8)):1}"
}

#OPS CASE

case $1 in 
	"S")
grabinfo
#Show Info
poolswap=$(zenity --list --radiolist \
  --title="Pool list" \
  --text="Select the pool you want to swap on top" \
  --width=650 --height=200 --timeout=20 \
  --column="Select" --column="Pool" --column="url" --column="worker" --column="password" \
TRUE "0" "${uwp[0,0]}" "${uwp[0,1]}" "${uwp[0,2]}" \
FALSE "1" "${uwp[1,0]}" "${uwp[1,1]}" "${uwp[1,2]}" \
FALSE "2" "${uwp[2,0]}" "${uwp[2,1]}" "${uwp[2,2]}" \
)
echo "$poolswap"
case $? in
	0)
	if [[ "$poolswap" -eq "0" ]]; then 
	$(zeninfo "Nothing has been change. Bye!") &
	elif [[ "$poolswap" -eq "1" ]] || [[ "$poolswap" -eq "2" ]]; then
#swap backup pool0
uwp[3,0]=${uwp[0,0]}
uwp[3,1]=${uwp[0,1]}
uwp[3,2]=${uwp[0,2]}
#place pool selected in pole position
uwp[0,0]=${uwp[$poolswap,0]}
uwp[0,1]=${uwp[$poolswap,1]}
uwp[0,2]=${uwp[$poolswap,2]}
#place old pool0 in new empty spot
uwp[$poolswap,0]=${uwp[3,0]}
uwp[$poolswap,1]=${uwp[3,1]}
uwp[$poolswap,2]=${uwp[3,2]}
#dump
		if $(zenques "Swap this pool to top\n\n<b>${uwp[0,0]}</b>\n\nand save ?"); then
		inject "$minerMode"
		curlAnyPost $poolData $url3 > /dev/null
		$(zeninfo "Change has been saved\nneed to reboot to take effect.") &
		else
		zeninfo "Nothing has been changed. Bye!"
		fi
	else
	zeninfo "Nothing has been changed. Bye!"
	fi
	;;
	1) $(zeninfo "Nothing has been changed. Bye!") ;;
	*) $(zenwarn "Something wrent wrong") ;;
esac

	;;
	"M")
grabinfo
	if [[ $minerMode -eq "0" ]]; then
	inject "1"
curlAnyPost $poolData $url3 > /dev/null
$(zeninfo "<b>High Performance</b> mode has been saved\n\nneed to reboot to take effect.")
	else
	inject "0"
curlAnyPost $poolData $url3 > /dev/null
$(zeninfo "<b>Normal</b> mode has been saved\n\nneed to reboot to take effect.")
	fi
	;;
	"R")
if $(zenques "Confirm <b>Reboot</b> ?"); then	
curlAnyPost 'reboot=1' $urlr > /dev/null
sleep 2
curlAnyPost '' $urlrb > /dev/null
fi	
	;;
	*) $(zeninfo "Nothing has been changed. Bye!") ;;
esac	
	
#logout
$(curlAnyGet $urlq) 2> /dev/null
	
unset i uwp
	
exit

















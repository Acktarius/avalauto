#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#    main
##################################################################
#
#variables and declarations

#zenity
zenInfo(){
    zenity --info --timeout=12 --text="$@"
    }
zenWarn(){
    zenity --warning --timeout=12 --text="$@"
    }
zenQues(){
    zenity --question --timeout=12 --text="$@"
    }

#check runner
if [[ -e .pid ]]; then
zenWarn "main sript already running,\ncome back later" &
exit
fi
#variables
declare -A pool
declare -a modeArr=("Normal" "Performance")
declare -i mode
#index
declare -A i
#Format
bold=$(tput bold)
normal=$(tput sgr0)

ip=$(cat .data)
#Declaratons
url="http://$ip/login.cgi"
url2="http://$ip/get_home.cgi"
url3="http://$ip/updatecgconf.cgi"
url4="http://$ip/cgconf.cgi"
urlr="http://$ip/reboot.cgi"
urlrb="http://$ip/reboot_btn.cgi"
urlq="http://$ip/logout.cgi"	

#function
strindex() { 
  x="${1%%"$2"*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

flipMode() {
local f=$(($1 - 1))
if [[ $f -lt "0" ]]; then
echo "${f#-}"
else
echo "$f"
fi
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

#Login
curlit () {
local credentialsZ=$(echo "$(gpg -d credentialsgpg)")
curlAnyPost $credentialsZ $url > /dev/null
unset credentialsZ
}
#reboot
curlReboot (){
curlAnyPost 'reboot=1' $urlr > /dev/null
sleep1
curlAnyPost "" $urlrb > /dev/null
}
#logout
#-H 'Content-Length: 0' ?
curlOut() {
curlAnyPost '' $urlq > /dev/null
}

#main

#Login
curlit
unset -f curlit
sleep 2

#GetPools in store
getPools(){
poolbrut=$(echo "$(curlAnyGet $url3)")
i[1,0]=$(strindex "$poolbrut" 'pool1":"')
i[1,1]=$(strindex "$poolbrut" 'worker1":"')
i[1,2]=$(strindex "$poolbrut" 'passwd1":"')
i[2,0]=$(strindex "$poolbrut" 'pool2":"')
i[2,1]=$(strindex "$poolbrut" 'worker2":"')
i[2,2]=$(strindex "$poolbrut" 'passwd2":"')
i[3,0]=$(strindex "$poolbrut" 'pool3":"')
i[3,1]=$(strindex "$poolbrut" 'worker3":"')
i[3,2]=$(strindex "$poolbrut" 'passwd3":"')
i["m"]=$(strindex "$poolbrut" 'mode":"')
#pool infos
for k in 1 2 3; do
pool["$k",0]=$(echo "${poolbrut:((${i["$k",0]}+8)):35}" | cut -d '"' -f 1 )
    for l in 1 2; do
    pool["$k","$l"]=$(echo "${poolbrut:((${i["$k","$l"]}+10)):25}" | cut -d '"' -f 1 )
    done
done
#getMode
mode=$(echo "${poolbrut:((${i["m"]}+7)):1}")

}

case $1 in
    "S")
getPools
z=$(zenity --list --radiolist --title="Select the Pool you want to swap on top" --timeout=25 --width=600 --height=200\
      --column "Select" --column "Pool#" --column "Pool" --column "Worker" \
      TRUE  "1" ${pool[1,0]} ${pool[1,1]} \
      FALSE "2" ${pool[2,0]} ${pool[2,1]} \
      FALSE "3" ${pool[3,0]} ${pool[3,1]})

    case $? in
        0)
for j in 0 1 2; do
pool[4,"$j"]=${pool[1,"$j"]}
pool[1,"$j"]=${pool["$z","$j"]}
pool["$z","$j"]=${pool[4,"$j"]}
done
        if (zenQues "${pool[1,0]}\n\nwill be in pole position\nConfirm ?" --width=450); then
        dataPool=$(echo "pool1=${pool[1,0]}&worker1=${pool[1,1]}&passwd1=${pool[1,2]}&pool2=${pool[2,0]}&worker2=${pool[2,1]}&passwd2=${pool[2,2]}&pool3=${pool[3,0]}&worker3=${pool[3,1]}&passwd3=${pool[3,2]}&mode=")
        dataToPost=$(echo ${dataPool}$mode)
        curlAnyPost "$dataToPost" $url4 > /dev/null
        zenInfo "Pool swap saved, you'll need to reboot\nfor those change to take effect" &
        fi
        ;;
        1)
        zenInfo "Nothing will be done" &
        curlOut
        exit
        ;;
        *)
        zenInfo "Nothing has been done" &
        curlOut
        exit
        ;;
    esac
    ;;
    "M")
getPools
dataPool=$(echo "pool1=${pool[1,0]}&worker1=${pool[1,1]}&passwd1=${pool[1,2]}&pool2=${pool[2,0]}&worker2=${pool[2,1]}&passwd2=${pool[2,2]}&pool3=${pool[3,0]}&worker3=${pool[3,1]}&passwd3=${pool[3,2]}&mode=")
echo $mode
if [[ "$mode" -ne "0" ]] && [[ "$mode" -ne "1" ]]; then
zenWarn "Something is wrong" &
curlOut
exit
else
    if (zenQues "You are in ${modeArr[$mode]} mode.\nDo you want to flip to ${modeArr[$(($mode -1))]} mode"); then
dataToPost=$(echo ${dataPool}$(flipMode $mode))
curlAnyPost "$dataToPost" $url4 > /dev/null
    if $(zenQues "${modeArr[$(($mode -1))]} is saved\nand will be applied after reboot.\nConfirm reboot now?"); then
    curlReboot
    fi
    fi
fi
    ;;
    "R")
if $(zenQues "Confirm reboot ?\nThat will implement the changed saved in pool or mode"); then
curlReboot
fi
    ;;
    *)
    zenWarn "Something is wrong" &
    curlOut
    exit
    ;;
esac    

#logout
curlOut

unset i mode pool modeArr

exit
#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  argos extension script
##################################################################
#variables and declarations
declare -a lastLine
declare -a poolInfo
#functions
color (){
if [[ $1 -ge $2 ]]; then
echo "#FF7F50"
else
echo "#1fc600"
fi
}
#Check 1
if [[ ! -f /opt/avalauto/credentialsgpg ]]; then
echo "Error :exclamation: | iconName=miner"
echo "---"
echo "no credentials"
echo "Run script: <span color='#1fc600'><b><u>first.sh</u></b></span> | bash=/opt/avalauto/first.sh terminal=false"
exit
fi
#Check 2
if [[ ! -f /opt/avalauto/.data ]]; then
echo "Error :exclamation: | iconName=miner"
echo "---"
echo "no IP address on record"
echo "Run script <span color='#1fc600'><b><u>second.sh</u></b></span> | bash=/opt/avalauto/second.sh terminal=false"
exit
fi
#get last line
if [[ ! -f /opt/avalauto/hashlog.txt ]]; then
echo "Error :exclamation: | iconName=miner"
echo "---"
echo "no hashlog yet"
echo ":hammer_and_pick:  <span color='#1fc600'><b><u>Run Script</u></b></span> | bash=/opt/avalauto/sc/launcher.sh terminal=false"
exit
fi
read -a lastLine <<< $(echo "$(tail -n 1 /opt/avalauto/hashlog.txt)")
lastDay=${lastLine[0]}
lastClock=${lastLine[1]}
hash=${lastLine[3]}
watt=${lastLine[6]}
ratio=${lastLine[8]}
status=${lastLine[11]}
tavg=${lastLine[13]}
laststamp=${lastLine[14]}
model=${lastLine[21]}
for ((k=22; k<24; k++)); do
if [[ -n ${lastLine[k]} ]]; then
model="$model ${lastLine[k]}"
fi
done

for ((i=15; i<20; i++)); do
poolInfo[$(($i-15))]=${lastLine[$i]}
done
mode=${lastLine[20]}

now=$(date +%s)
delta=$(( $now - $laststamp  ))



#extension
echo "| iconName=miner"
echo "---"
echo "-> <span color='#4d4dff'>$model</span>"
echo "on <span color='$(color $delta "1800")'>$lastDay</span> at <span color='$(color $delta "1800")'>$lastClock</span> | size=10"
echo "Hash <span color='#1fc600'>${hash}</span> TH/s at <span color='#1fc600'>${watt}</span> Watt"
echo "Status <span color='$(color "0" $status)'>$status</span> Ratio: <span color='#1fc600'>${ratio}</span> W/H/s"
echo "Temp avg <span color='$(color $tavg 70)'>$tavg</span>"
echo "Mode <span color='#1fc600'>$mode</span> at next boot | size=10"
echo "---"
echo "Pool info"
echo "--${poolInfo[0]} | size=9"
echo "--worker: ${poolInfo[1]} | size=9"
echo "--accepted share: ${poolInfo[2]} | size=9"
echo "--rejected share: ${poolInfo[3]}    <span color='$(color $(printf '%.0f\n' ${poolInfo[4]}) 2)'>${poolInfo[4]}%</span> | size=9"
echo "Miner Ops"
echo "--Swap pools | bash=/opt/avalauto/sc/miner_opsS.sh terminal=false"
echo "--Change Mode &#128260; | bash=/opt/avalauto/sc/miner_opsM.sh terminal=false"
echo "--:exclamation: Reboot Miner | bash=/opt/avalauto/sc/miner_opsR.sh terminal=false"
echo "---"
echo ":hammer_and_pick:  Run Script | bash=/opt/avalauto/sc/launcher.sh terminal=false"
echo "empty :wastebasket: log and :hammer_and_pick: Run | bash=/opt/avalauto/sc/trashlog.sh terminal=false"

unset lastLine poolInfo

exit
#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#  argos extemsion script
##################################################################
#variables
lastDay=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 1)
lastClock=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 2)
hash=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 4)
watt=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 7)
ratio=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 9)
status=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 12)
tmax=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 14)
laststamp=$(tail -n 1 /opt/avalauto/hashlog.txt | cut -d " " -f 15)

now=$(date +%s)
delta=$(( $now - $laststamp  ))

#functions
color (){
if [[ $1 -ge $2 ]]; then
echo "#FF7F50"
else
echo "#1fc600"
fi
}

#extension
echo "Avalon | iconName=miner"
echo "---"
echo "on <span color='$(color $delta "3600")'>$lastDay</span> at <span color='$(color $delta "3600")'>$lastClock</span> | size=10"
echo "Hash <span color='#1fc600'>${hash}</span> TH/s at <span color='#1fc600'>${watt}</span> Watt"
echo "Status <span color='$(color "0" $status)'>$status</span> Ratio: <span color='#1fc600'>${ratio}</span> W/H/s"
echo "Temp max <span color='$(color $tmax 72)'>$tmax</span>"
echo ":hammer_and_pick:  Run Script | bash=/opt/avalauto/launcher.sh terminal=false"
echo "empty :wastebasket: log | bash=/opt/avalauto/trashlog.sh terminal=false"

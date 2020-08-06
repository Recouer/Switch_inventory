#!/bin/bash

switchs=($(cat ./feedMeSwitchs.txt))

SWITCH=./SwitchData/tmp/switch.txt
SWITCH_PORT=./SwitchData/tmp/switchPort.txt
SWITCH_VLAN=./SwitchData/tmp/switchVlan.txt

read -p "username:" user
read -s -p "password:" pass


for switch in ${switchs[@]}
do
    check=$(./src/checkConnect.sh $switch $user $pass)
    echo $check
    case "$check" in
	"connectionAccepted")
	    
    
	    ./src/setData.sh $switch $user $pass
	    ./src/dataFormat.sh
	    
	    name=($(cut -b 1-$b $SWITCH))
	    str="${name[-1]}"
	    M_name="${str%\#*}"
    

	    cat ./SwitchData/tmp/switch.txt > ./SwitchData/Data/$M_name/switch.txt
	    cat ./SwitchData/tmp/switchPort.txt > ./SwitchData/Data/$M_name/switchPort.txt
	    cat ./SwitchData/tmp/switchVlan.txt > ./SwitchData/Data/$M_name/switchVlan.txt
	    ;;
	"connectionRefused")
	    echo " $switch ; Connection Refused " > ./Rendu/$switch.csv
	    ;;
	"connectionTimedOut")
	    echo " $switch ; Connection Timed Out " > ./Rendu/$switch.csv
	    ;;
    esac
done

#!/bin/bash

switchs=($(cat ./feedMeSwitchs.txt))

SWITCH=./SwitchData/tmp/switch.txt
SWITCH_PORT=./SwitchData/tmp/switchPort.txt

read -p "username:" user
read -s -p "password:" pass

for switch in ${switchs[@]}
do
    ./src/setData.sh $switch $user $pass
    ./src/dataFormat.sh

    name=($(cut -b 1-$b $SWITCH))
    str="${name[-1]}"
    M_name="${str%\#*}"
    

    cat ./SwitchData/tmp/switch.txt > ./SwitchData/Data/$M_name/switch.txt
    cat ./SwitchData/tmp/switchPort.txt > ./SwitchData/Data/$M_name/switchPort.txt
done

#!/bin/bash

SERVER=$1
USER=$2
PASS=$3
PROTOCOL=$4

DATA=./SwitchData/tmp/temp.txt

./src/getData.sh $SERVER $USER $PASS $PROTOCOL "Show version" > $DATA
./src/getData.sh $SERVER $USER $PASS $PROTOCOL "Show version" > $DATA

get_switch_data() {
    switchName=$1
    bin=$(grep $switchName $DATA)
    if [[ ! -z "$bin" ]]
    then
	portsNb=$2
	portsName=$3
	portsNameSize=$4
    fi
}

####    Add Here    ####
get_switch_data "WS-C2960-24PC-L" "24" "Fa0/" "6"
get_switch_data "WS-C3560-24PS" "24" "Fa0/" "6"
get_switch_data "C9300-24" "24" "Gi1/0/" "9"

if [[ -z $portsNb ]]
then
    cat $DATA
    ./src/getData.sh $SERVER $USER $PASS $PROTOCOL "Show interface status"
    echo ""
    
    read -p "switchName:" switchName
    read -p "portsNb:" portsNb
    read -p "portsName:" portsName
    portsNameSize=$(expr ${#portsName} + 2)

    sed -i "24 a get_switch_data \"$switchName\" \"$portsNb\" \"$portsName\" \"$portsNameSize\"" ./src/getConfig.sh
fi

if [[ -z $5 ]]
then
    echo "$switchName" "$portsNb" "$portsName" "$portsNameSize"
fi

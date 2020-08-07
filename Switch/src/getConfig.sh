#!/bin/bash

SERVER=$1
USER=$2
PASS=$3
PROTOCOL=$4

DATA=./SwitchData/tmp/temp.txt

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

get_switch_data "C9300-24" "24" "Gi1/0/" "9"
echo "$portsNb" "$portsName" "$portsNameSize"

if [[ -z $portsNb ]]
then
    echo "Switch not Registered"
    exit
fi

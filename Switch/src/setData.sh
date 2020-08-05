#!/bin/bash

SERVER=$1
USER=$2
PASS=$3

DATA=./SwitchData/tmp/temp.txt
PORT_INFO=./SwitchData/tmp/switchPort.txt
SWITCH_INFO=./SwitchData/tmp/switch.txt

./src/getData.sh $SERVER $USER $PASS "Show interface status" > $DATA
 > $PORT_INFO


tail --lines=+14 $DATA > $SWITCH_INFO


PORTS=($(cut -b 1-6 $DATA))
PORTS=("${PORTS[@]:13}")

if (( ${#PORTS[@]} > 30 )); then
    n=5
else
    n=3
fi

name=($(cut -b 1-$b $SWITCH_INFO))
str="${name[-1]}"
M_name="${str%\#*}"
mkdir ./SwitchData/Data/$M_name
> ./SwitchData/Data/$M_name/switchPortRaw.txt


for ((i=0;i<$(expr ${#PORTS[@]} - $n);i++))
do
    echo "Show mac address-table ${PORTS[$i]}"
    ./src/getData.sh $SERVER $USER $PASS "Show mac address-table interface ${PORTS[$i]}" > $DATA

    cat $DATA >> ./SwitchData/Data/$M_name/switchPortRaw.txt
    
    IFS=$'\n'
    data=($(cat $DATA))
    IFS=' '
    
    for ((j=16;j<$(expr ${#data[@]} - 2);j++))
    do
	echo ${data[$j]} >> $PORT_INFO
    done
done


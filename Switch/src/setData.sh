#!/bin/bash

SERVER=$1
USER=$2
PASS=$3

DATA=./SwitchData/tmp/temp.txt
PORT_INFO=./SwitchData/tmp/switchPort.txt
SWITCH_INFO=./SwitchData/tmp/switch.txt
VLAN_INFO=./SwitchData/tmp/switchVlan.txt

./src/getData.sh $SERVER $USER $PASS "Show interface status" > $DATA
tail --lines=+14 $DATA > $SWITCH_INFO

> $PORT_INFO

PORTS=($(cut -b 1-6 $DATA))
PORTS=("${PORTS[@]:13}")


if (( ${#PORTS[@]} > 30 ))
then
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


echo "" >> $VLAN_INFO

./src/getData.sh $SERVER $USER $PASS "Show vlan" > $DATA
tail --lines=+15 $DATA > $VLAN_INFO

cat $VLAN_INFO > ./SwitchData/Data/$M_name/switchVlanRaw.txt

vlan=($(cut -b 1-5 $VLAN_INFO))
name=($(cut -b 6-25 $VLAN_INFO))


for ((i=0;i<${#vlan[@]};i++))
do
    if [[ ${vlan[$i]} == "VLAN" ]]
    then
	echo " ${vlan[$i]} ; ${name[$i]} " >> $VLAN_INFO
    fi
done

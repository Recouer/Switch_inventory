#!/bin/bash

SERVER=$1
USER=$2
PASS=$3
PROTOCOL=$4
portsNb=$5
portsName=$6
portsNameSize=$7

DATA=./SwitchData/tmp/temp.txt
PORT_INFO=./SwitchData/tmp/switchPort.txt
SWITCH_INFO=./SwitchData/tmp/switch.txt
SWITCH_RAW=./SwitchData/tmp/switchRaw.txt
VLAN_INFO=./SwitchData/tmp/switchVlan.txt


./src/getData.sh $SERVER $USER $PASS $PROTOCOL "Show interface status" > $DATA

cat $DATA > $SWITCH_RAW
grep "$portsName" $DATA > $SWITCH_INFO
grep "$portsName" $SWITCH_INFO > $DATA
PORTS=($(cut -b 1-$portsNameSize $DATA))
PORTS=("${PORTS[@]:0:$portsNb}")


> $PORT_INFO



name=($(grep ".*#" $SWITCH_RAW))
echo $name >> $SWITCH_INFO
str="${name[-1]}"
M_name="${str%\#*}"
mkdir ./SwitchData/Data/$M_name
> ./SwitchData/Data/$M_name/switchPortRaw.txt
cat $SWITCH_RAW > ./SwitchData/Data/$M_name/switchRaw.txt


for ((i=0;i<$(expr ${#PORTS[@]});i++))
do
    echo -en "\rShow mac address-table ${PORTS[$i]}"
    ./src/getData.sh $SERVER $USER $PASS $PROTOCOL "Show mac address-table interface ${PORTS[$i]}" > $DATA
    
    cat $DATA >> ./SwitchData/Data/$M_name/switchPortRaw.txt
    
    IFS=$'\n'
    data=($(grep ${PORTS[$i]} $DATA))
    IFS=' '
    
    for ((j=1;j<${#data[@]};j++))
    do
	echo ${data[$j]} >> $PORT_INFO
    done
done


echo "" >> $VLAN_INFO

./src/getData.sh $SERVER $USER $PASS $PROTOCOL "Show vlan" > $DATA
grep 'active' $DATA > $VLAN_INFO
grep 'act/unsup' $DATA >> $VLAN_INFO

cat $DATA > ./SwitchData/Data/$M_name/switchVlanRaw.txt


vlan=($(cut -b 1-5 $VLAN_INFO | tr -d '\r' | tr -d '\n'))
name=($(cut -b 6-25 $VLAN_INFO | tr -d '\r' | tr -d '\n'))

echo " vlan ; name "> $VLAN_INFO

for ((i=0;i<${#vlan[@]};i++))
do
    echo " ${vlan[$i]} ; ${name[$i]} " >> $VLAN_INFO
done


cat ./SwitchData/tmp/switch.txt > ./SwitchData/Data/$M_name/switch.txt
cat ./SwitchData/tmp/switchPort.txt > ./SwitchData/Data/$M_name/switchPort.txt
cat ./SwitchData/tmp/switchVlan.txt > ./SwitchData/Data/$M_name/switchVlan.txt

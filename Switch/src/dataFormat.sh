#!/bin/bash

# set the repertory where the temporary files are stored
SWITCH=./SwitchData/tmp/switch.txt
SWITCH_PORT=./SwitchData/tmp/switchPort.txt
SWITCH_VLAN=./SwitchData/tmp/switchVlan.txt
TEMP=./SwitchData/tmp/temp.txt

switch=$1
portsNb=$2
portsName=$3
portsNameSize=$4
b="${b:-29}"



# get the data from the extracted files
IFS=$'\n'
port=($(cut -b 1-$portsNameSize $SWITCH | tr -d ' '))
name=($(cut -b 1-$b $SWITCH))
status=($(cut -b $(expr $b + 1)-$(expr $b + 13) $SWITCH))
vlan=($(cut -b $(expr $b + 14)-$(expr $b + 18) $SWITCH))
duplex=($(cut -b $(expr $b + 19)-$(expr $b + 30) $SWITCH))
speed=($(cut -b $(expr $b + 31)-$(expr $b + 37) $SWITCH))
type=($(cut -b $(expr $b + 38)-$(expr $b + 52) $SWITCH))


p_vlan=($(cut -d ' ' -f1 $SWITCH_PORT))
p_mac=($(cut -d ' ' -f2 $SWITCH_PORT))
p_port=($(cut -d ' ' -f4 $SWITCH_PORT | tr -d '\r'))


v_vlan=($(cut -d ' ' -f1 $SWITCH_VLAN))
v_name=($(cut -d ' ' -f2 $SWITCH_VLAN))
IFS=' '

# create file where the formated data will be returned
str="${name[-1]}"
M_name="${str%\#*}"
RENDU=./Rendu/$M_name.csv


# create the heading of the file
echo " ; Description ; Vlan ; Mac active ; Adresse IP ; Marque ; Hostname ; Service ; Contact ; Tel ; Nom " > $RENDU
echo "$M_name ; $switch" >> $RENDU


# print the formated data inside the file
for ((i=0;i<${#port[@]};i++))
do
    a=1
    for ((j=0;j<${#p_port[@]};j++))
    do
	if [[ "${port[$i]}" == "${p_port[$j]}" ]]
	then
	    echo "${port[$i]} ; ${name[$i]:10} ; ${p_vlan[$j]} ; ${p_mac[$j]} ; ; ; ; ; ; ; ; ${status[$i]} ; ${duplex[$i]} ; ${speed[$i]} ; ${type[$i]}" >> $RENDU
	    a=0
	fi
    done
    if ((a)); then
	echo "${port[$i]} ; ${name[$i]:10} ; ${vlan[$i]} ; ; ; ; ; ; ; ; ; ${status[$i]} ; ${duplex[$i]} ; ${speed[$i]} ; ${type[$i]}" >> $RENDU
    fi
done

echo " " >> $RENDU
cat $SWITCH_VLAN >> $RENDU

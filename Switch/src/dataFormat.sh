#!/bin/bash

SWITCH=./SwitchData/tmp/switch.txt
SWITCH_PORT=./SwitchData/tmp/switchPort.txt
TEMP=./SwitchData/tmp/temp.txt

b=$1
b="${b:-29}"

port=($(cut -b 1-6 $SWITCH))
name=($(cut -b 1-$b $SWITCH))
status=($(cut -b $(expr $b + 1)-$(expr $b + 13) $SWITCH))
vlan=($(cut -b $(expr $b + 14)-$(expr $b + 18) $SWITCH))
duplex=($(cut -b $(expr $b + 19)-$(expr $b + 30) $SWITCH))
speed=($(cut -b $(expr $b + 31)-$(expr $b + 37) $SWITCH))
type=($(cut -b $(expr $b + 38)-$(expr $b + 52) $SWITCH))

str="${name[-1]}"
M_name="${str%\#*}"

RENDU=./Rendu/$M_name.csv

p_vlan=($(cut -d ' ' -f1 $SWITCH_PORT))
p_mac=($(cut -d ' ' -f2 $SWITCH_PORT))
p_port=($(cut -d ' ' -f4 $SWITCH_PORT | tr -d '\r'))



echo " ; Vlan ; Description ; Mac active ; Adresse IP ; Marque ; Hostname ; Service ; Contact ; Tel ; Nom " > $RENDU
echo "$M_name" >> $RENDU

m=0

for ((i=0;i<${#port[@]};i++))
do
    a=1
    for ((j=0;j<${#p_port[@]};j++)); do
	if [[ "${port[$i]}" == "${p_port[$j]}" ]]
	then
	    m=$(expr $m + 1)
	    echo "${port[$i]} ; ${p_vlan[$j]} ;  ; ${p_mac[$j]} ; ; ; ; ; ; ; ; ${status[$i]} ; ${duplex[$i]} ; ${speed[$i]} ; ${type[$i]}" >> $RENDU
	    a=0
	fi
    done
    if ((a)); then
	echo "${port[$i]} ; ${vlan[$i]} ; ; ; ; ; ; ; ; ; ; ${status[$i]} ; ${duplex[$i]} ; ${speed[$i]} ; ${type[$i]}" >> $RENDU
    fi
done

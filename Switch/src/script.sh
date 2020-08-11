#!/bin/bash

protocols=("ssh" "telnet")

SWITCH=./SwitchData/tmp/switch.txt
SWITCH_PORT=./SwitchData/tmp/switchPort.txt
SWITCH_VLAN=./SwitchData/tmp/switchVlan.txt


# prompt the user to identify themselves
read -p "username:" user
read -s -p "password:" pass


for protocol in ${protocols[@]}
do
    echo -e "\n$protocol"
    # get the ip addresses from the ./feedMeSwitchs.txt file in which the data will be
    # processed
    switchs=($(cat ./feedMeSwitchs.txt))
    > ./feedMeSwitchs.txt
    for switch in ${switchs[@]}
    do
	# check wether the user managed to connect to the switch using a given protocol
	# and will act accordingly depending on the answer
	check=$(./src/checkConnect.sh $switch $user $protocol)
	echo -e "\n$check $switch"
	case "$check" in
	    "connectionAccepted")

		# if the user managed to identify themselves using the given protocol, the data
		# will then be processed using the setData.sh and dataFormat.sh script, and
		# the raw data will be stored in another directory
		./src/getConfig.sh $switch $user $pass $protocol 1
		SC=($(./src/getConfig.sh $switch $user $pass $protocol))
		./src/setData.sh $switch $user $pass $protocol ${SC[1]} ${SC[2]} ${SC[3]}
		./src/dataFormat.sh ${SC[0]} ${SC[1]} ${SC[2]} ${SC[3]}
		;;
	
	    "connectionRefused")
		echo $switch >> ./feedMeSwitchs.txt
		#echo " $switch ; Connection Refused " > ./Rendu/$switch.csv
		;;
	
	    "connectionTimedOut")
		echo $switch >> ./feedMeSwitchs.txt
		#echo " $switch ; Connection Timed Out " > ./Rendu/$switch.csv
		;;
	esac
    done
done

> ./Result/leftover.txt

switchs=($(cat ./feedMeSwitchs.txt))
for switch in ${switchs[@]}
do
    ping $switch -W 5 -c 1 > $DATA
    status=$(grep "0 received" $DATA)
    if [[ -z "$status" ]]
    then
	echo "$switch ; signal Received" > ./Result/leftOver.csv
    else
	echo "$switch ; no signal Received" > ./Result/leftOver.csv
    fi
done

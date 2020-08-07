#!/bin/bash

protocols=("ssh" "telnet")

SWITCH=./SwitchData/tmp/switch.txt
SWITCH_PORT=./SwitchData/tmp/switchPort.txt
SWITCH_VLAN=./SwitchData/tmp/switchVlan.txt

user=vanaertselaer.d
pass=11061999Dam

# prompt the user to identify themselves
#read -p "username:" user
#read -s -p "password:" pass


for protocol in ${protocols[@]}
do
    echo $protocol
    # get the ip addresses from the ./feedMeSwitchs.txt file in which the data will be
    # processed
    switchs=($(cat ./feedMeSwitchs.txt))
    #> ./feedMeSwitchs.txt
    for switch in ${switchs[@]}
    do
	# check wether the user managed to connect to the switch using a given protocol
	# and will act accordingly depending on the answer
	check=$(./src/checkConnect.sh $switch $user $protocol)
	echo $check
	case "$check" in
	    "connectionAccepted")

		# if the user managed to identify themselves using the given protocol, the data
		# will then be processed using the setData.sh and dataFormat.sh script, and
		# the raw data will be stored in another directory
		SC=($(./src/getConfig.sh $switch $user $pass $protocol))
		if [[ "Switch not Registered" == $SC ]]
		then
		    echo "ble"
		    exit
		fi
		./src/setData.sh $switch $user $pass $protocol ${SC[0]} ${SC[1]} ${SC[2]}
		./src/dataFormat.sh ${SC[0]} ${SC[1]} ${SC[2]}
		
		name=($(cut -b 1-$b $SWITCH))
		str="${name[-1]}"
		M_name="${str%\#*}"
		

		cat ./SwitchData/tmp/switch.txt > ./SwitchData/Data/$M_name/switch.txt
		cat ./SwitchData/tmp/switchPort.txt > ./SwitchData/Data/$M_name/switchPort.txt
		cat ./SwitchData/tmp/switchVlan.txt > ./SwitchData/Data/$M_name/switchVlan.txt
		;;
	
	    "connectionRefused")
		#echo $switch >> ./feedMeSwitchs.txt
		#echo " $switch ; Connection Refused " > ./Rendu/$switch.csv
		;;
	
	    "connectionTimedOut")
		#echo " $switch ; Connection Timed Out " > ./Rendu/$switch.csv
		;;
	esac
    done
done

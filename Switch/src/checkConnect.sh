#!/bin/bash

host=$1
user=$2
prot=$3

# get information from trying to connect to the switch
show_data_telnet() {
expect << EOF
set timeout 2
set host $host
spawn telnet $host
expect {
       "username:"  { send "exit\r" }
}
EOF
}

show_data_ssh() {
expect << EOF
set timeout 2
set host $host
spawn ssh $user@$host
expect "?"
EOF
}



# extract the relevant information
case $prot in
    "telnet")
	IFS=$'\r'
	bin=($(show_data_telnet | tr -d '\n'))
	IFS=' '
	;;
    "ssh")
	IFS=$'\r'
	show_data_ssh
	bin=($(show_data_ssh | tr -d '\n'))
	IFS=' '
	;;
esac


# return the result depending on the extracted data
case $prot in
    "telnet")
	case ${bin[2]} in
	    "Connected to $1.")
		echo "connectionAccepted"
		;;
	    "telnet: Unable to connect to remote host: Connection refused")
		echo "connectionRefused"
		;;
	    "")
		echo "connectionTimedOut"
		;;
	esac
	;;
    "ssh")
	case ${bin[1]} in
	    "The authenticity "*)
		echo "connectionAccepted"
		;;
	    "C")
		echo "connectionAccepted"
		;;		
	    "Unable to "*)
		echo "connectionRefused"
		;;
	    *)
		echo "connectionTimedOut"
		;;
	esac
	;;
esac

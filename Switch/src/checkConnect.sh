#!/bin/bash

server=$1
user=$2
pass=$3

show_data() {
    host=$1
    cmd=$2
expect << EOF
set timeout 2
set host $host
set user $user
set pass $pass
spawn telnet $host
expect "username:"
EOF
}

IFS=$'\r'
bin=($(show_data $server "$4" | tr -d '\n'))

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
 

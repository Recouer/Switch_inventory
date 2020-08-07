#!/bin/sh

host=$1
user=$2
pass=$3
prot=$4
cmd=$5

# function used for giving commands to the switch using telnet protocol
show_data_telnet() {
expect << EOF
set timeout 10
set host $host
set user $user
set pass $pass
spawn telnet $host
expect "username:"
send "$user\r"
expect "password:"
send "$pass\r"
expect -re ".*#"
send "$cmd\r"
send "\r"
expect -re ".*#"
send "exit\r"
EOF
}

# function used for giving commands to the switch using ssh protocol
show_data_ssh() {
expect << EOF
set timeout 10
set host $host
set user $user
set pass $pass
spawn ssh  $user@$host
expect "?"
send "yes"
expect "password:"
send "$pass\r"
expect -re ".*#"
send "$cmd\r"
expect {
       " --More-- " { send "\r"; exp_continue }
       -re ".*#"    { send "exit\r"}
}
EOF
}



# return the data received
echo '---------------------------------------------'
echo "$host"
case $prot in
    "telnet")
	show_data_telnet
	;;
    "ssh")
	show_data_ssh
	;;
esac

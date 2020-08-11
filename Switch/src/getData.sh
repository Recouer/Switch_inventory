#!/bin/sh

host=$1
user=$2
pass=$3
prot=$4
cmd=$5

# function used for giving commands to the switch using telnet protocol
show_data_telnet() {
expect << EOF
<<<<<<< HEAD
set timeout 10
=======
set timeout 4
>>>>>>> b4792b1047006feeed2d9d239e7ada0dbd891975
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
expect {
       " --More-- " { send "\r"; exp_continue }
       -re ".*#"    { send "exit\r"}
}
EOF
}

# function used for giving commands to the switch using ssh protocol
show_data_ssh() {
expect << EOF
<<<<<<< HEAD
set timeout 10
=======
set timeout 4
>>>>>>> b4792b1047006feeed2d9d239e7ada0dbd891975
set host $host
set user $user
set pass $pass
spawn ssh  $user@$host
<<<<<<< HEAD
expect { 
       "?assword:"     { send "$pass\r" }
       "Are you sure"  { send "yes" }
}
=======
expect "?"
send "yes"
expect "password:"
send "$pass\r"
>>>>>>> b4792b1047006feeed2d9d239e7ada0dbd891975
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

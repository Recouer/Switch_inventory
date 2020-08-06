#!/bin/sh

server=$1
user=$2
pass=$3

show_data() {
    host=$1
    cmd=$2
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



for ip in $server; do
  echo '---------------------------------------------'
  echo "$ip"
  show_data $ip "$4"
done

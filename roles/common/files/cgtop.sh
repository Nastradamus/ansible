#!/bin/bash
#title        :cgtop
#description  :This script use systemctl for monitoring Tasks, CPU, Memmory used by unit.
#author       :Igor Sidorenko
#usage        :Use: ./cgtop.sh sshd.service cpu
#==============================================================================

tasks=$(systemd-cgtop -n1 | grep "$1" | awk '{print $2}')
cpu=$(systemctl status "$1" | grep CPU | awk '{print $2}')
mem=$(systemd-cgtop -n1 | grep "$1" | awk '{print $4}'| sed 's/[A-Za-z]//g')
parse_mem=$(systemd-cgtop -n1 | grep "$1" | awk '{print $4}'| sed 's/[0-9\.]//g')

b=1024

if [[ "$2" == 'tasks' && -n $tasks && "$tasks" != '-' ]]; then
    printf '%s\n' "$tasks"

elif [[ "$2" == 'tasks' && -z $tasks ]]; then
    echo "0"

elif [[ "$2" == 'tasks' && "$tasks" == '-' ]]; then
    echo "0"

elif [ "$2" == 'cpu' ]; then
    printf '%s\n' "$cpu"

elif [[ "$2" == 'mem' && -n $mem  && "$mem" != '-' ]]; then

    if [ "$parse_mem" == 'K' ]; then
        mem=$(echo "$mem * $b" | bc)
        printf '%s\n' "$mem"

    elif [ "$parse_mem" == 'M' ]; then
        mem=$(echo "$mem * $b * $b" | bc)
        printf '%s\n' "$mem"

    elif [ "$parse_mem" == "G" ]; then
        mem=$(echo "$mem * $b * $b * $b" | bc)
        printf '%s\n' "$mem"
    fi

elif [[ "$2" == 'mem' && -z $mem ]]; then
    echo "0"

elif [[ "$2" == 'mem' && $mem == '-' ]]; then
    echo "0"
fi
exit

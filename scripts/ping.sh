#!/bin/bash

# USAGE: ./ping.sh google.com espn.com

CHECK_HOSTS=("$@")

for host in "${CHECK_HOSTS[@]}"
do
    if ping -c 1 $host > /dev/null
    then
        echo "$host is up."
    else
        echo "$host is down."
    fi
done

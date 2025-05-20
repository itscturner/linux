#!/bin/bash

# Bash script to monitor disk usage, and alert if it is above the set threshold.

# Set the threshold for disk usage (in percentage)
threshold=90

# Get the disk usage percentage
disk_usage=$(df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//')

if [ "$disk_usage" -ge "$threshold" ]; then
    echo "  ERROR:  Disk space is running low, Disk Usage: $disk_usage%"
else
    echo "  OK:  Disk Usage: $disk_usage%"
fi

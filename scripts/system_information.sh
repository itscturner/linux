#!/bin/bash

echo ""
echo "----- System Information -----"
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo "Uptime: $(uptime -p)"

echo ""

echo "----- Manufacturer & Model -----"
echo "Manufacturer: $(sudo dmidecode -s system-manufacturer)"
echo "Model: $(sudo dmidecode -s system-product-name)"

echo ""

echo "----- OS Information -----"
echo "OS Name: $(cat /etc/os-release | grep "NAME")"
echo "OS Version: $(cat /etc/os-release | grep "VERSION")"

echo ""

echo "----- CPU Information -----"
echo "Model Name: $(cat /proc/cpuinfo | grep "model name" | uniq | awk '{ print $4,"",$5,"",$6 }')"
echo "Cores: $(cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{ print $4 }')"
echo "Processors: $(grep "processor" /proc/cpuinfo | wc -l)"

echo ""

echo "----- Memory Information -----"
free -h

echo ""

echo "----- Disk Usage -----"
echo "Root Filesystem Usage: $((df -h / | awk 'NR==2 { print $5 }')
echo "Disk Space Usage:"
df -h

echo ""

echo "----- Top Processes -----"
echo "Top 5 Processes:"
ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -n 6

echo ""

echo "----- Network Information -----"
echo "IP Address: $(hostname -i)"
echo "MAC Address:"
cat /sys/class/net/*/address
echo "Routing Table:"
route

echo ""

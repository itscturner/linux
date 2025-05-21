#!/bin/bash

DIR=`echo $@ | awk '{ print $NF }`

# Check For Root
if [ "`/usr/sbin/dmidecode 2>&1 | grep -ic 'Permission denied'`" != "0" \; then
  echo ""
  echo "  Must be root..."
  echo ""
  exit 1
fi

# Check Disk Usage
if echo $DIR | egrep '^($|.+\*)' > /dev/null
then
  echo ""
  echo "  USAGE: $0 [DIRECTORY]"
  echo ""
else
  if [ ! $DIR ]
    then
      echo ""
      echo " PROCESSING $DIR :"
      echo ""
      du -s $DIR/* | sort -n | awk '{
  
      P=10
      M="KB";
      S=($1*1024)

      if (S>=(2**20)) {P=20;M="MB";}
      if (S>=(2**30)) {P=30;M="GB";}
      if (S>=(2**40)) {P=40;M="TB";}
      if (S>=(2**50)) {P=50;M="PB";}

      printf "  %8.3f %2s %s\n",(S/(2**P)),M, $2

      }'
      echo ""
  fi
fi

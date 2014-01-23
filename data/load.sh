#!/bin/sh

GRAPHITE_HOST=192.168.33.10

POINTS=( `cat "$1"` )
LENGTH=${#POINTS[@]}

NOW=`date +%s`
TIME=$(($NOW + 24 * 60 * 60))

for (( INDEX=0; INDEX<$LENGTH; INDEX+=1 )); do
  echo $1 ${POINTS[$INDEX]} $TIME | nc $GRAPHITE_HOST 2003
  TIME=$(($TIME - 60))
done

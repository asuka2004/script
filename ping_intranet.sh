#!/bin/bash
CMD="ping -w 2 -c 2"
IP="192.168.88."
for n in `seq 10` 
do
	$CMD $IP$n &>/dev/null
	if [ $? -eq 0 ];then
		echo "$IP$n is OK"
	fi


done

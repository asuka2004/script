#!/bin/bash

if [ `netstat -ntulp|grep 11211 |wc -l` -lt 1 ]
	then
		echo "memcache is error"
		exit 1
fi

printf "del key\r\n"| nc -v 127.0.0.1 11211 &>/dev/null
printf "set key 0 0 10 \r\n\r\n"| nc -v 127.0.0.1 11211 &>/dev/null
McValues=`printf "get key\r\n"|nc -v 127.0.0.1 11211|grep |wc -l`

if [ $McValues -eq 1 ]
	then
	 echo "Mem is ok"
else
	 echo "not ok"
fi

#!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:07
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

trap "find /tmp -type f -name "_*" |xargs rm -rf && exit" INT
while true
do
	touch /tmp/_$(date +F-%H-%M-%S)
	sleep
	ls -l /tmp/*
done
 

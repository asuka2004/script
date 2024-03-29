#!/bin/bash
# Author      : Kung
# Build       : 2022-04-12 23:58
# Version     : V1.0
# Description : Batch add/del Network Card IP Address           
# System      : CentOS 7.9 

export PS4='++ ${LINENO} ' 
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

RETVAL=0
add(){
	for ip in {1..5}
	do
		if [ $ip -eq 10 ]
		 then
		continue
		fi
		
	ip addr add 192.168.88.$ip/24 dev eth0 label eth0:$ip &>/dev/null
	RETVAL=$?

		if [ $RETVAL -eq 0 ]
		 then
			action "Success to add 192.168.88.$ip" /bin/true
		else
			action "Fail to add 192.168.88.$ip" /bin/false
		fi
	done
	return $RETVAL
}

del(){
	for ip in {5..1}
	do
		if [ $ip -eq 10 ]
		 then
			continue
		fi

	ifconfig eth0:$ip down &>/dev/null
	RETVAL=$?

		if [ $RETVAL -eq 0 ]
		 then
			action "Success to del 192.168.88.$ip" /bin/true
		else
			action "Fail to del 192.168.88.$ip" /bin/false
		fi
	done
	return $RETVAL
}

case "$1" in
	start)
		add
		;;
	stop)
		del
		;;
	restart)
		del
		sleep 2
		add
		;;
	*)
		printf "Usage:$0 {start|stop|restart}\n"

esac
exit $RETVAL

#!/bin/bash
# Author:   Kung
# Function: monitor nginx

if [ `netstat -ntulp|grep nginx|wc -l` -gt 0 ];then
	echo  "Web is running"  
else
	echo "Web will reboot"
	/usr/bin/systemctl restart nginx
fi

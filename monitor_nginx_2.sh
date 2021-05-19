#!/bin/bash

counter=$(ps -C nginx --no-heading|wc -l)
if [ "${counter}" -eq "0" ]; then
	/usr/bin/systemctl stop keepalived 
	echo 'NGINX Server is dead..Please fix this Nginx'
else
	/usr/bin/systemctl start keepalived
fi

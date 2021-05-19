#!/bin/bash
#Author : Kung
#Function: uptime save
while [ 1 ]
do
 uptime >>/root/uptime.log
 usleep 5 
done

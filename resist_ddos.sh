#!/bin/bash
#Author:Kung
#Function: resist ddos attack

file=$1
while true
do
 awk '{print $1}' $1 | grep -v "^$"|sort|uniq -c >/root/tmp.log
 exec</root/tmp.log
 while read line
  do
	ip=`echo $line|awk '{print $2}'`
	count=`echo $line|awk '{print $1}'`
	if [ $count -gt 30 ];then
	firewall-cmd --add-rich-rule "rule family="ipv4" source address="$ip" port port="80" protocol="tcp"  reject"
	echo "$line is dropped">>/root/droplist_$(date +F%).log
	fi
  done
  sleep 20
done

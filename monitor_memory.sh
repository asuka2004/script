#!/bin/bash
#Author:Kung
#Function: monitor memory


Memory=`free -m|awk 'NR==2 {print $NF}'`
Alarm="Warining!!! Current time is `date +%F-%T` and Memory leave over $Memory"
if [ $Memory -lt 3500 ]
 then
	echo $Alarm>> /root/message.txt
	mail -s "`date +%F-%T` $Alarm" root@localhost</root/message.txt

fi
 

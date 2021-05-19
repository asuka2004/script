#!/bin/bash
#Author:  Kung
#Function:random file

Path=/root/

[ -d $Path ]|| mkdir /root/github
for n in `seq 5`
do
	random=$(openssl rand -base64 20 | sed 's#[^a-z]##g'| cut -c 2-5) 
	touch $Path/${random}_Kung.html
done 

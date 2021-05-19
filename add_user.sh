#!/bin/bash
#author:  Kung
#subject: add new account&password
. /etc/init.d/functions
user="student"
passfile="/root/github/userpasswd.log"

for num in `seq -w 05 `
do
 pass="`echo $RANDOM |md5sum|cut -c 3-5`"
 useradd $user$num &>/dev/null && echo -e "user:$user$num\tpasswd:$pass">>$passfile
 if [ $? -eq 0 ]
  then
	action "$user$num add new account" /bin/true
 else
	action "$user$num fail account" /bin/false
 fi


done
#subject: del user
#del account
# for n in student{01..05} 
#do 
#	userdel -r $n 
#done

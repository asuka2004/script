#!/bin/bash

checkurl(){
timeout=10
fails=0
success=0

while true
 do
 wget --timeout=$timeout --tries=5 http://www.gss.sscom -q -O /dev/null
 if [ $? -ne 0 ]
  then
        ((fails=fails+1))
  else
	((success=success+1))
 fi
 
 if [ $fails -ge 1 ]
  then
	critical="Waining!!!!websit is going down"
	echo $critical|tee|mail -s "$critical" root@localhost
	exit 2
 fi

 if [ $success -ge 2 ]
  then
	echo "success"
	exit 0
 fi

 done
}
checkurl

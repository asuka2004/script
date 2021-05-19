#!/bin/bash
#Author: Kung
#Subject:  url check

. /etc/init.d/functions
url_count=0
url_list=(
www.google.com
www..roc
www.yahoo.com.tw
)
function url_check(){
	for((i=0;i<`echo ${#url_list[*]}`;i++  ))
	do
		wget -o /dev/null -T 3 --tries=1 --spider ${url_list[$i]}>/dev/null 2>&1
		if [ $? -eq 0 ];then
			action "${url_list[$i]}" /bin/true
		else
			action "${url_list[$i]}" /bin/false
		fi		
	done
	((url_count++))
}

function main(){
	while true
	do
		url_check
		echo "Please wait five second!!! The Count is $url_count time "
		sleep 5  
	done
}
main 

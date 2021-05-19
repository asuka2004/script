#!/bin/bash
# Author: Kung
# Subject: test break continue exit return

if [ $# -ne 1 ];then
	echo "Please input {break|continue|exit|return}"
	exit 1
fi

test(){
 for ((i=0;i<=5;i++))
 do
	if [ $i -eq 3 ];then
		$*	
	fi
	echo $i	
 done
 echo " in func"
}
test $*
 

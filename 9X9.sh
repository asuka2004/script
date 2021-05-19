#!/bin/bash

for num1 in `seq 9`
do
 for num2 in `seq 9`
  do
	if [ $num1 -ge $num2 ]
	  then
		if(((num1*num2)>9))
		 then
		   echo -en "${num1}X${num2}=$((num1*num2)) "
	  	
	         else
		   echo -en "${num1}X${num2}=$((num1*num2))  "
		fi
	fi	

  done
echo " "
done
#author:
 

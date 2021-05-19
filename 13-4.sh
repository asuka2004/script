#!/bin/bash
#author:
#subject: array
array=(a b c d e f)
for ((i=0;i<${#arr[*]};i++))
do
 if [ ${#array[$i]} -lt 2 ];then
	echo "${array[$i]}"
 fi
done

#!/bin/bash
sum=0

while read line
do
 size=`echo $line |awk '{print $10}'`
 expr $size + 1 &>/dev/null
 if [ $? -ne 0 ]
  then
	continue
 fi
 ((sum=sum+$size))
done<$1
echo "Total: `echo $((${sum}))`"

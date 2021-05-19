#!/bin/bash
#############
i=1
sum=0
while [ $i -lt 10 ]
do
 ((sum=sum+i))

 ((i++))

done

[ "$sum" -ne 0 ] && printf "totalsum is : $sum\n"

#author:
 

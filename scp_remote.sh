#!/bin/bash
#Author: Kung
#Function: scp file to remote server
if [ $# -ne 2 ];then
	echo $"Usage:$0 file dir"
	exit
fi
file=$1
dir=$2

for n in 101 102 
do
	expect scp_remote.exp $file 192.168.88.$n $dir
done

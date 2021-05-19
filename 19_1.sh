#!/bin/bash
Path=/root/test
[ -d "$PATH" ]|| mkdir -p $Path

for n in `seq 10`
do
	random=$(openssl rand -base64 40| sed 's#[^a-z]##g'|cut -c 1-10)
	touch $Path/${random}_.html
done
#author:
 

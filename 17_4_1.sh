#!/bin/bash

trap "find /tmp -type f -name "_*" |xargs rm -rf && exit" INT
while true
do
	touch /tmp/_$(date +F-%H-%M-%S)
	sleep
	ls -l /tmp/*
done
#author:
 

#!/bin/bash
#Author: Kung
#Function: rename a lot of file

NewFile=_asuka.html
Dirname="/root"
cd $Dirname||exit 1
for n in `ls`
do
	name=$(echo $n|awk -F '_' '{print $1}' )
	mv $n ${name}${NewFile}
done

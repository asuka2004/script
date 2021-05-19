#!/bin/bash
#Author: Kung
#Subject: Auto Git	
	git add * 
	git commit -m $(date +%m/%d-%H:%M)
	git push -u origin master

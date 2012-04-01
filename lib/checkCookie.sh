#!/bin/sh

checkCookie() {
	if [ -e $FILE_COOKIE ]; then		
		now=`date +%s`
		lastModified=`stat -t %s $FILE_COOKIE | awk '{print $10}' | sed 's/"\([0-9]*\)"/\1/'`
		diff=`expr $now - $lastModified`
	
		if [ $diff -gt $TTL_COOKIE ]; then
			rm -f $FILE_COOKIE
		fi
	fi
}
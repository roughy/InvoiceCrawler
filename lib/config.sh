#!/bin/sh

# read content of a configuration file
readConfig() {
	filename=$PATH_CONFIG/$1
	if [ ! -f "$filename" ]; then
		echo "" > $filename
	fi
	
	# include file
	. $filename
}

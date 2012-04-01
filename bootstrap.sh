#!/bin/sh

# include files
. $PATH_ROOT/include/constants.sh
. $PATH_ROOT/lib/readInput.sh
. $PATH_ROOT/lib/config.sh
. $PATH_ROOT/lib/checkbin.sh
. $PATH_ROOT/lib/checkCookie.sh

bootstrap() {
	# read config
	readConfig $FILE_CONFIG

	# read input
	readParameter $*
	
	# check and delete cookie file
	checkCookie
}
